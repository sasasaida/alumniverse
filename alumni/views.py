from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from django.utils.crypto import get_random_string
from django.utils.timezone import now
from .forms import AlumniProfileForm, StudentProfileForm, ProfileFilterForm
from .db import execute_query, get_db_connection
from django.http import Http404, HttpResponse, HttpResponseForbidden
import os
from django.conf import settings
from django.utils import timezone
from datetime import date
import uuid
from django.views.decorators.http import require_POST


def home(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM events ORDER BY date DESC LIMIT 6")
            events = cursor.fetchall()
            cursor.execute("SELECT * FROM admin_notifications ORDER BY created_at DESC LIMIT 6")
            notifications = cursor.fetchall()
            cursor.execute("SELECT * FROM job_postings ORDER BY deadline DESC LIMIT 6")
            jobs = cursor.fetchall()
            cursor.execute("""
                SELECT e.*, a.picture, a.full_name
                FROM exemplary_achievements e
                JOIN alumni_profile a ON e.alumni_id = a.alumni_id
                ORDER BY e.date_posted DESC
                LIMIT 6
            """)
            achievements = cursor.fetchall()
            cursor.execute("""
                    SELECT 
                        t.content, 
                        t.date_posted, 
                        CASE 
                            WHEN ap.full_name IS NOT NULL THEN ap.full_name
                            ELSE sp.full_name
                        END AS full_name,
                        u.role
                    FROM Testimonials t
                    JOIN Users u ON t.user_id = u.user_id
                    LEFT JOIN alumni_profile ap ON u.user_id = ap.user_id
                    LEFT JOIN student_profile sp ON u.user_id = sp.user_id
                    WHERE t.approved = 1
                    ORDER BY t.date_posted DESC
                    LIMIT 1
                """)
            testimonials = cursor.fetchall()

            cursor.execute("""
                            SELECT * FROM gallery_images
                            ORDER BY uploaded_at DESC
                            LIMIT 6
                        """)
            gallery_preview = cursor.fetchall()

    return render(request, 'home.html', {'events': events, 'notifications': notifications, 'jobs': jobs, 'achievements': achievements, 'testimonials': testimonials, 'gallery_preview': gallery_preview,})

def user_login(request):
    if request.user.is_authenticated:
        return redirect('home')

    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        # Query user
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                                    SELECT * FROM users
                                    WHERE username = %s AND password = %s
                                """, (username, password))
                user_db = cursor.fetchone()


                if user_db is None:
                    messages.error(request, "Invalid username or password.")
                    return redirect('login')
                user = User.objects.get(pk=user_db['user_id'])

                if user_db['role'] == 'admin' and not user.is_staff:
                    messages.error(request, "Awaiting approval.")
                    return redirect('login')

                if user_db['is_active']:
                    login(request, user)  # Django login
                    messages.success(request, 'Logged in successfully.')
                    if user_db['role']== 'admin':
                        return redirect('admin_dashboard')
                    else:
                        return redirect('profile')
                else:
                    messages.error(request, "Account Deactivated")

    return render(request, 'authentication/login.html')

def user_logout(request):
    logout(request)
    messages.success(request, 'Logged out successfully.')
    return redirect('home')


def register(request):
    if request.user.is_authenticated:
        messages.success(request, 'Already Registered')
        return redirect('home')

    if request.method == 'POST':
        username = request.POST['username']
        email = request.POST['email']
        password1 = request.POST['password1']
        password2 = request.POST['password2']
        role = request.POST['role']
        full_name = request.POST['full_name']
        department = request.POST['department']
        batch = request.POST.get('batch', '')
        job_title = request.POST.get('job_title', '')
        company = request.POST.get('company', '')
        linkedin = request.POST.get('linkedin', '')
        bio = request.POST.get('bio', '')
        year = request.POST.get('year', '')
        interests = request.POST.get('interests', '')
        picture = request.FILES.get('picture')
        uni_id = request.POST.get('uni_id')

        if password1 != password2:
            messages.error(request, 'Passwords do not match.')
            return redirect('register')

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # 1. Check if uni_id exists in the pre-approved table for the role
                cursor.execute("""
                            SELECT COUNT(*) as count FROM valid_university_ids 
                            WHERE uni_id = %s AND role = %s
                        """, (uni_id, role))
                if int(cursor.fetchone()['count']) == 0:
                    messages.error(request, 'Invalid or unauthorized University ID for this role.')
                    return redirect('register')

                # Check username
                cursor.execute("SELECT COUNT(*) as count FROM users WHERE username = %s", [username])
                if int(cursor.fetchone()['count']) > 0:
                    messages.error(request, 'Username taken.')
                    return redirect('register')

        if role not in ['student', 'alumni', 'admin']:
            messages.error(request, 'Invalid role.')
            return redirect('register')

        if role == 'alumni' and not batch:
            messages.error(request, 'Batch is required for alumni.')
            return redirect('register')

        if role == 'alumni' and linkedin and not linkedin.startswith('https://www.linkedin.com/'):
            messages.error(request, 'Invalid LinkedIn URL.')
            return redirect('register')

        if role == 'student':
            if not year:
                messages.error(request, 'Year is required for students.')
                return redirect('register')

            try:
                year = int(year) if year else 0
                if role == 'student' and year <= 0:
                    messages.error(request, 'Year must be a positive integer.')
                    return redirect('register')
            except ValueError:
                messages.error(request, 'Invalid year.')
                return redirect('register')

        # Create User
        user = User.objects.create_user(username=username, email=email, password=password1)
        user.save()
        user_id = user.id

        # Handle picture
        picture_path = None
        if picture:
            picture_path = f"profiles/{role}/{username}_{picture.name}"
            with open(os.path.join(settings.MEDIA_ROOT, picture_path), 'wb+') as f:
                for chunk in picture.chunks():
                    f.write(chunk)

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # Insert into userprofile
                cursor.execute("""
                    INSERT INTO users (user_id, username, email, password, role)
                    VALUES (%s, %s, %s, %s, %s)
                """, (user_id, username, email, password1, role))
                conn.commit()

                # Insert into alumni or student profile
                if role == 'alumni':
                    cursor.execute("""
                        INSERT INTO alumni_profile 
                        (alumni_id, user_id, full_name, batch, department, job_title, company, linkedin, bio, picture)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, (
                        f"A{user_id:03d}", user_id, full_name, batch, department,
                        job_title or None, company or None, linkedin or None,
                        bio or None, picture_path
                    ))
                    conn.commit()
                elif role == 'student':
                    cursor.execute("""
                        INSERT INTO student_profile 
                        (student_id, user_id, full_name, department, year, interests, picture)
                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                    """, (
                        f"S{user_id:03d}", user_id, full_name, department,
                        year, interests or None, picture_path
                    ))
                    conn.commit()

        if role == 'admin':
            messages.info(request, 'Admin account created. Awaiting approval from staff.')
        else:
            login(request, user)
            messages.success(request, 'Account created successfully.')
        return redirect('home')

    return render(request, 'authentication/register.html')


@login_required
def profile(request):
    user_id = request.user.id
    active_mentorship = []
    current_mentees = []
    completed_mentorship = []
    achievements = []
    jobs_posted = []
    testimonials = []
    drafts = []

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            query = "SELECT role FROM users WHERE user_id = %s"
            cursor.execute(query, (user_id,))
            role = cursor.fetchone()['role']

            if role == 'alumni':
                query = """
                    SELECT alumni_id, full_name, batch, department, job_title, company, linkedin, bio, picture
                    FROM alumni_profile WHERE user_id = %s
                """
                cursor.execute(query, (user_id,))
                profile = cursor.fetchone()

                #Active mentees
                cursor.execute("""
                            SELECT m.mentorship_id, m.start_date, m.status,
                                   s.full_name AS student_name, s.department
                            FROM mentorship m
                            JOIN student_profile s ON m.mentee_id = s.student_id
                            WHERE m.mentor_id = %s AND m.status = 'Active'
                        """, (profile['alumni_id'],))
                current_mentees = cursor.fetchall()

                # Completed mentorship
                cursor.execute("""
                                        SELECT m.mentorship_id, m.start_date, m.status,
                                               s.full_name AS student_name, s.department
                                        FROM mentorship m
                                        JOIN student_profile s ON m.mentee_id = s.student_id
                                        WHERE m.mentor_id = %s AND m.status = 'Completed'
                                    """, (profile['alumni_id'],))
                completed_mentorship = cursor.fetchall()

                # Achievements by this alumni
                cursor.execute("""
                                    SELECT achievement_id, title, content, date_posted
                                    FROM exemplary_achievements
                                    WHERE alumni_id = %s
                                    ORDER BY date_posted DESC
                                """, (profile['alumni_id'],))
                achievements = cursor.fetchall()

                # Jobs posted by this alumni
                cursor.execute("""
                                    SELECT job_id, title, description, company, deadline
                                    FROM job_postings
                                    WHERE alumni_id = %s
                                    ORDER BY deadline DESC
                                """, (profile['alumni_id'],))
                jobs_posted = cursor.fetchall()


            elif role == 'student':
                query = """
                    SELECT *
                    FROM student_profile WHERE user_id = %s
                """
                cursor.execute(query, (user_id,))
                profile = cursor.fetchone()

                #Active mentorship
                cursor.execute("""
                            SELECT m.mentorship_id, m.start_date, m.status,
                                   a.full_name AS mentor_name, a.department
                            FROM mentorship m
                            JOIN alumni_profile a ON m.mentor_id = a.alumni_id
                            WHERE m.mentee_id = %s AND m.status = 'Active'
                        """, (profile['student_id'],))
                active_mentorship = cursor.fetchall()

                # Completed mentorship
                cursor.execute("""
                                       SELECT m.mentorship_id, m.start_date, m.status,
                                              a.full_name AS mentor_name, a.department
                                       FROM mentorship m
                                       JOIN alumni_profile a ON m.mentor_id = a.alumni_id
                                       WHERE m.mentee_id = %s AND m.status = 'Completed'
                                   """, (profile['student_id'],))
                completed_mentorship = cursor.fetchall()

                #drafts
                cursor.execute("""
                                SELECT * FROM student_drafts 
                                WHERE student_id = %s 
                                ORDER BY draft_id DESC
                            """, (profile['student_id'],))
                drafts = cursor.fetchall()

            # Testimonials
            cursor.execute("""
                SELECT testimonial_id, content, date_posted
                FROM testimonials
                WHERE user_id = %s AND approved = 1
                ORDER BY date_posted DESC
            """, (user_id,))
            testimonials = cursor.fetchall()

    return render(request, 'profile/profile.html', {
                                                                'profile': profile,
                                                                'role': role,
                                                                'active_mentorship': active_mentorship,
                                                                'current_mentees': current_mentees,
                                                                'completed_mentorship': completed_mentorship,
                                                                'achievements': achievements,
                                                                'jobs_posted': jobs_posted,
                                                                'testimonials': testimonials,
                                                                'drafts': drafts
                                                                })


@login_required
def update_profile(request):
    user_id = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            query = "SELECT role FROM users WHERE user_id = %s"
            cursor.execute(query, (user_id,))
            role = cursor.fetchone()['role']

            FormClass = AlumniProfileForm if role == 'alumni' else StudentProfileForm
            if role == 'alumni':
                query = "SELECT * FROM alumni_profile WHERE user_id = %s"
                cursor.execute(query,(user_id,))
                profile = cursor.fetchone()
                print(f"     profile: {profile}                 ")

            else:
                query = "SELECT * FROM student_profile WHERE user_id = %s"
                cursor.execute(query, (user_id,))
                profile = cursor.fetchone()
                print(f"     profile: {profile}                 ")

            if request.method == 'POST':
                form = FormClass(request.POST, request.FILES)
                if form.is_valid():
                    data = form.cleaned_data
                    old_picture_path = profile['picture']
                    picture_path = old_picture_path  # Default to old picture if no change

                    # Handle picture
                    if data['remove_picture'] and old_picture_path:
                        if os.path.isfile(os.path.join(settings.MEDIA_ROOT, old_picture_path)):
                            os.remove(os.path.join(settings.MEDIA_ROOT, old_picture_path))
                        picture_path = None
                    elif 'picture' in request.FILES:
                        if old_picture_path and os.path.isfile(os.path.join(settings.MEDIA_ROOT, old_picture_path)):
                            os.remove(os.path.join(settings.MEDIA_ROOT, old_picture_path))
                        picture_path = f"profiles/{role}/{request.user.username}_{request.FILES['picture'].name}"
                        with open(os.path.join(settings.MEDIA_ROOT, picture_path), 'wb+') as f:
                            for chunk in request.FILES['picture'].chunks():
                                f.write(chunk)

                    if role == 'alumni':
                        query = """
                            UPDATE alumni_profile
                            SET full_name = %s, department = %s, batch = %s, job_title = %s, company = %s, linkedin = %s, bio = %s, picture = %s
                            WHERE user_id = %s
                        """
                        params = (
                            data['full_name'], data['department'], data['batch'], data['job_title'] or None,
                            data['company'] or None, data['linkedin'] or None, data['bio'] or None, picture_path, user_id
                        )
                    elif role == 'student':
                        query = """
                            UPDATE student_profile
                            SET full_name = %s, department = %s, year = %s, interests = %s, picture = %s
                            WHERE user_id = %s
                        """
                        params = (
                            data['full_name'], data['department'], data['year'], data['interests'] or None, picture_path,
                            user_id
                        )

                    execute_query(query, params)
                    messages.success(request, 'Profile updated successfully.')
                    return redirect('profile')
                else:
                    messages.error(request, 'Please correct the errors below.')
            else:
                form = FormClass(initial=profile)

    return render(request, 'profile/update_profile.html', {'form': form, 'role': role})


def public_profiles_list(request):
    form = ProfileFilterForm(request.GET or None)
    alumni_query = """
            SELECT a.* FROM alumni_profile a
            JOIN users u ON a.user_id = u.user_id
            WHERE u.is_active = 1
        """
    student_query = """
            SELECT s.* FROM student_profile s
            JOIN users u ON s.user_id = u.user_id
            WHERE u.is_active = 1
        """
    params_alumni = []
    params_student = []

    # Get search query
    query = request.GET.get('q', '').strip()
    if query:
        alumni_query += " AND a.full_name LIKE %s"
        student_query += " AND s.full_name LIKE %s"
        search_param = f"%{query}%"
        params_alumni.append(search_param)
        params_student.append(search_param)

    # Apply filters
    if form.is_valid():
        department = form.cleaned_data.get('department')
        batch = form.cleaned_data.get('batch')
        year = form.cleaned_data.get('year')

        if department:
            alumni_query += " AND a.department = %s"
            student_query += " AND s.department = %s"
            params_alumni.append(department)
            params_student.append(department)
        if batch:
            alumni_query += " AND a.batch = %s"
            params_alumni.append(batch)
        if year:
            student_query += " AND s.year = %s"
            params_student.append(year)

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(alumni_query, params_alumni)
            alumni_profiles = cursor.fetchall()
            cursor.execute(student_query, params_student)
            student_profiles = cursor.fetchall()

    return render(request, 'profile/public_profiles_list.html', {
        'alumni_profiles': alumni_profiles,
        'student_profiles': student_profiles,
        'form': form,
        'query': query
    })


def public_profile_detail(request, profile_id):
    achievements = []
    jobs_posted = []
    testimonials = []
    drafts = []

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if profile_id.startswith('A'):
                query = "SELECT * FROM alumni_profile WHERE alumni_id = %s"
                cursor.execute(query, (profile_id,))
                profile = cursor.fetchone()
                role = 'alumni'

                # Achievements by this alumni
                cursor.execute("""
                                SELECT achievement_id, title, content, date_posted
                                FROM exemplary_achievements
                                WHERE alumni_id = %s
                                ORDER BY date_posted DESC
                            """, (profile['alumni_id'],))
                achievements = cursor.fetchall()

                # Jobs posted by this alumni
                cursor.execute("""
                                    SELECT job_id, title, description, company, deadline
                                    FROM job_postings
                                    WHERE alumni_id = %s
                                    ORDER BY deadline DESC
                                """, (profile['alumni_id'],))
                jobs_posted = cursor.fetchall()

                # Testimonials
                cursor.execute("""
                    SELECT t.content, t.date_posted
                    FROM testimonials t
                    JOIN alumni_profile a ON t.user_id = a.user_id
                    WHERE a.alumni_id = %s AND t.approved = 1
                    ORDER BY t.date_posted DESC
                """, (profile['alumni_id'],))
                testimonials = cursor.fetchall()

            elif profile_id.startswith('S'):
                query = "SELECT * FROM student_profile WHERE student_id = %s"
                cursor.execute(query, (profile_id,))
                profile = cursor.fetchone()
                role = 'student'

                #drafts
                cursor.execute("""
                                SELECT * FROM student_drafts 
                                WHERE student_id = %s 
                                ORDER BY draft_id DESC
                            """, (profile['student_id'],))
                drafts = cursor.fetchall()

                # Testimonials
                cursor.execute("""
                                    SELECT t.content, t.date_posted
                                    FROM testimonials t
                                    JOIN student_profile a ON t.user_id = a.user_id
                                    WHERE a.student_id = %s AND t.approved = 1
                                    ORDER BY t.date_posted DESC
                                """, (profile['student_id'],))
                testimonials = cursor.fetchall()

            else:
                raise Http404("Invalid profile ID")

            if not profile:
                raise Http404("Profile not found")

    return render(request, 'profile/public_profile_detail.html', {'profile': profile, 'role': role, 'achievements': achievements, 'jobs_posted': jobs_posted, 'testimonials': testimonials, 'drafts': drafts})






@login_required
def register_for_event(request):
    user_id = request.user.id
    today = date.today()
    registered_users = []
    event_id = request.GET.get('event_id') or request.POST.get('event_id')

    # Get all upcoming events
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT *
                FROM events
                WHERE event_id = %s
            """, [event_id])
            event = cursor.fetchone()

            # Handle form actions
            if request.method == 'POST' and event_id:
                action = request.POST.get('action')

                # Check if already registered
                cursor.execute("""
                    SELECT 1 FROM event_registration
                    WHERE user_id = %s AND event_id = %s
                """, [user_id, event_id])
                already_registered = cursor.fetchone()

                if action == 'register' and already_registered:
                    messages.error(request, 'Already registered.')

                if action == 'register' and not already_registered:
                    registration_id = 'R' + uuid.uuid4().hex[:6].upper()
                    registration_date = date.today()

                    cursor.execute("""
                        INSERT INTO event_registration (registration_id, user_id, event_id, registration_date)
                        VALUES (%s, %s, %s, %s)
                    """, [registration_id, user_id, event_id, registration_date])
                    conn.commit()
                    messages.success(request, 'Successfully Registered!')

                elif action == 'cancel' and already_registered:
                    cursor.execute("""
                        DELETE FROM event_registration
                        WHERE user_id = %s AND event_id = %s
                    """, [user_id, event_id])
                    conn.commit()
                    messages.success(request, 'Registration Cancelled')

    # Fetch registered users for selected event
    if event_id:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    SELECT 
                        CASE 
                            WHEN al.full_name IS NOT NULL THEN al.full_name
                            ELSE st.full_name
                        END AS full_name,
                        up.role,
                        er.registration_date
                    FROM event_registration er
                    JOIN users up ON er.user_id = up.user_id
                    LEFT JOIN alumni_profile al ON up.user_id = al.user_id
                    LEFT JOIN student_profile st ON up.user_id = st.user_id
                    WHERE er.event_id = %s
                    ORDER BY er.registration_date ASC
                """, [event_id])
                registered_users = cursor.fetchall()

    return render(request, 'event/event_register.html', {
        'event': event,
        'event_id': event_id,
        'registered_users': registered_users,
        'today': today,
    })

def events_list(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            query = "SELECT * FROM events ORDER BY date DESC"
            cursor.execute(query)
            events = cursor.fetchall()

    return render(request, 'event/events.html', {'events': events})





@login_required
def add_job_posting(request):
    user_id = request.user.id

    #Check role
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", [user_id])
            result = cursor.fetchone()

            if not result or result['role'] != 'alumni':
                return render(request, 'unauthorized.html')  # Optional access control

    if request.method == 'POST':
        title = request.POST['title']
        company = request.POST['company']
        description = request.POST['description']
        deadline = request.POST['deadline']
        job_id = 'JOB_' + uuid.uuid4().hex[:6].upper()

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    SELECT alumni_id FROM alumni_profile
                    WHERE user_id = %s
                """, [user_id])
                result = cursor.fetchone()
                if not result:
                    messages.error(request, "Alumni profile not found.")
                    return redirect('add_job_posting')

                alumni_id = result['alumni_id']

                cursor.execute("""
                    INSERT INTO job_postings (job_id, title, company, description, deadline, alumni_id)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, [job_id, title, company, description, deadline, alumni_id])

                conn.commit()

        messages.success(request, 'Job post successful')
        return redirect('view_jobs')

    return render(request, 'job postings/add_job_posting.html')



def edit_job_posting(request, job_id):
    user_id = request.user.id

    # Get the alumni_id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", [user_id])
            alumni_result = cursor.fetchone()

            if not alumni_result:
                messages.error(request, 'You must be an alumni to edit job postings.')
                return redirect('home')

            alumni_id = alumni_result['alumni_id']

            # Fetch the job posting
            cursor.execute("""
                SELECT title, company, description, deadline
                FROM job_postings
                WHERE job_id = %s AND alumni_id = %s
            """, [job_id, alumni_id])
            job = cursor.fetchone()

            if not job:
                messages.error(request, 'Unauthorized or job does not exist.')
                return redirect('home')

            # Handle form submission
            if request.method == 'POST':
                title = request.POST['title']
                company = request.POST['company']
                description = request.POST['description']
                deadline = request.POST['deadline']


                cursor.execute("""
                    UPDATE job_postings
                    SET title = %s, company = %s, description = %s, deadline = %s
                    WHERE job_id = %s AND alumni_id = %s
                """, [title, company, description, deadline, job_id, alumni_id])

                conn.commit()
                messages.success(request, 'Job post updated successfully.')
                return redirect('home')

    # Pre-fill the form data
    job_data = {
        'title': job['title'],
        'company': job['company'],
        'description': job['description'],
        'deadline': job['deadline'].strftime('%Y-%m-%d') if job['deadline'] else '',
        'job_id': job_id
    }

    return render(request, 'job postings/edit_job_posting.html', {'job': job_data})


def view_jobs(request):
    user_id = request.user.id
    search_query = request.GET.get('q', '').strip()  # 1. Get search input

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Get user role
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None

            # 2. Filter job postings by title or company if search query exists
            if search_query:
                cursor.execute("""
                    SELECT j.job_id, j.title, j.description, j.company, j.alumni_id, a.full_name
                    FROM job_postings j
                    JOIN alumni_profile a ON j.alumni_id = a.alumni_id
                    WHERE j.title LIKE %s OR j.company LIKE %s OR j.description LIKE %s
                """, (f"%{search_query}%", f"%{search_query}%", f"%{search_query}%"))
            else:
                cursor.execute("""
                    SELECT j.job_id, j.title, j.description, j.company, j.alumni_id, a.full_name
                    FROM job_postings j
                    JOIN alumni_profile a ON j.alumni_id = a.alumni_id
                """)
            jobs = cursor.fetchall()

    # Prepare context
    job_list = []
    for row in jobs:
        job_list.append({
            'job_id': row['job_id'],
            'title': row['title'],
            'description': row['description'],
            'company': row['company'],
            'posted_by': row['alumni_id'],
            'poster_name': row['full_name'],
            'can_edit': (role == 'alumni' and user_id == row['alumni_id'])
        })

    return render(request, 'job postings/view_jobs.html', {
        'jobs': job_list,
        'search_query': search_query  # 3. Send search query back to template (for input persistence)
    })



def job_details(request, job_id):
    # Fetch the job details
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT j.job_id, j.title, j.description, j.company, j.alumni_id, j.deadline, COALESCE(a.full_name, 'Unknown') as poster_name 
                FROM job_postings j
                LEFT JOIN alumni_profile a ON j.alumni_id = a.alumni_id
                WHERE j.job_id = %s
            """, (job_id,))

            job = cursor.fetchone()
            print('job: ',job)

    if job is None:
        messages.error(request, 'no job found.')
        return render(request, 'job_details.html', {'job': None, 'can_edit': False})

    # Fetching if the user can edit (only alumni who posted the job)
    user_id = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None

            alumni_id = None
            if role == 'alumni':
                cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
                alumni_row = cursor.fetchone()
                alumni_id = alumni_row['alumni_id'] if alumni_row else None

    can_edit = (role == 'alumni' and alumni_id == job['alumni_id'])

    return render(request, 'job postings/job_details.html', {
        'job': job,
        'can_edit': can_edit
    })



@login_required
@require_POST
def delete_job(request, job_id):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Get role and alumni_id of logged-in user
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_row = cursor.fetchone()
            role = role_row['role'] if role_row else None

            cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
            alumni_row = cursor.fetchone()
            alumni_id = alumni_row['alumni_id'] if alumni_row else None

            # Get job posting to check owner
            cursor.execute("SELECT alumni_id FROM job_postings WHERE job_id = %s", (job_id,))
            job_row = cursor.fetchone()
            if not job_row:
                messages.error(request, "Job not found.")
                return redirect('job_list')  # use your actual job list URL name

            # Authorization check
            if role != 'alumni' or alumni_id != job_row['alumni_id']:
                messages.error(request, "You are not authorized to delete this job.")
                return redirect('job_details', job_id=job_id)

            # Delete job
            cursor.execute("DELETE FROM job_postings WHERE job_id = %s", (job_id,))
            conn.commit()

    messages.success(request, "Job deleted successfully.")
    return redirect('view_jobs')






def view_achievements(request):
    user_id = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Get user role
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None

            # Get all achievements
            cursor.execute("""
                SELECT 
                    e.achievement_id,
                    e.title,
                    e.content,
                    e.date_posted,
                    e.alumni_id,
                    CASE 
                        WHEN a.full_name IS NOT NULL THEN a.full_name
                        ELSE 'Unknown'
                    END AS poster_name
                FROM exemplary_achievements e
                LEFT JOIN alumni_profile a ON e.alumni_id = a.alumni_id
                ORDER BY e.date_posted DESC
            """)
            rows = cursor.fetchall()

    achievements = []
    for row in rows:
        achievements.append({
            'achievement_id': row['achievement_id'],
            'title': row['title'],
            'content': row['content'],
            'date_posted': row['date_posted'],
            'alumni_id': row['alumni_id'],
            'poster_name': row['poster_name'],
        })

    return render(request, 'achievements/view_achievements.html', {'achievements': achievements})

@login_required
def achievement_details(request, achievement_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT 
                    e.achievement_id, 
                    e.title, 
                    e.content, 
                    e.date_posted, 
                    e.alumni_id,
                    CASE 
                        WHEN a.full_name IS NOT NULL THEN a.full_name
                        ELSE 'Unknown'
                    END AS poster_name
                FROM exemplary_achievements e
                LEFT JOIN alumni_profile a ON e.alumni_id = a.alumni_id
                WHERE e.achievement_id = %s

            """, (achievement_id,))
            achievement = cursor.fetchone()

    if not achievement:
        messages.error(request, 'Achievement not found.')
        return render(request, 'achievements/achievement_details.html', {'achievement': None, 'can_edit': False})


    # Check if user can edit
    user_id = request.user.id
    role = None
    alumni_id = None
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None
            if role == 'alumni':
                cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
                alumni_row = cursor.fetchone()
                alumni_id = alumni_row['alumni_id'] if alumni_row else None

    can_edit = (role == 'alumni' and alumni_id == achievement['alumni_id'])

    return render(request, 'achievements/achievement_details.html', {
        'achievement': achievement,
        'can_edit': can_edit
    })

@login_required
def edit_achievement(request, achievement_id):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Fetch the achievement
            cursor.execute("""
                SELECT achievement_id, title, content, date_posted, alumni_id
                FROM exemplary_achievements
                WHERE achievement_id = %s
            """, (achievement_id,))
            achievement = cursor.fetchone()


    if not achievement:
        messages.error(request, "Achievement not found.")
        return redirect('view_achievements')

    # Check if user is allowed to edit
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None
            cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
            alumni_id = cursor.fetchone()['alumni_id']


    if not (role == 'alumni' and alumni_id == achievement['alumni_id']):
        messages.error(request, "You're not authorized to edit this achievement.")
        return redirect('achievement_details', achievement_id=achievement_id)

    if request.method == "POST":
        title = request.POST.get('title')
        content = request.POST.get('content')
        #date_posted = request.POST.get('date_posted')  # YYYY-MM-DD

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    UPDATE exemplary_achievements
                    SET title = %s, content = %s
                    WHERE achievement_id = %s
                """, (title, content, achievement_id))
                conn.commit()

        messages.success(request, "Achievement updated successfully.")
        return redirect('achievement_details', achievement_id=achievement_id)

    return render(request, 'achievements/edit_achievement.html', {'achievement': achievement})


@login_required
def delete_achievement(request, achievement_id):
    user_id = request.user.id

    # Step 1: Fetch achievement to check if it exists and who posted it
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT alumni_id
                FROM exemplary_achievements
                WHERE achievement_id = %s
            """, (achievement_id,))
            achievement = cursor.fetchone()

    if not achievement:
        messages.error(request, "Achievement not found.")
        return redirect('view_achievements')

    # Step 2: Verify user is the owner
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_row = cursor.fetchone()
            role = role_row['role'] if role_row else None

            cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
            alumni_row = cursor.fetchone()
            alumni_id = alumni_row['alumni_id'] if alumni_row else None

    if role != 'alumni' or alumni_id != achievement['alumni_id']:
        messages.error(request, "You're not authorized to delete this achievement.")
        return redirect('achievement_details', achievement_id=achievement_id)

    # Step 3: Perform the delete operation
    if request.method == "POST":
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    DELETE FROM exemplary_achievements
                    WHERE achievement_id = %s
                """, (achievement_id,))
                conn.commit()
        messages.success(request, "Achievement deleted successfully.")
        return redirect('view_achievements')

    # If somehow accessed via GET, redirect back
    return redirect('achievement_details', achievement_id=achievement_id)




@login_required
def add_achievement(request):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None

            if role != 'alumni':
                messages.error(request, "Only alumni can add achievements.")
                return redirect('home')

            cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
            alumni_result = cursor.fetchone()

            if not alumni_result:
                messages.error(request, "No alumni profile found.")
                return redirect('home')

            alumni_id = alumni_result['alumni_id']

    if request.method == "POST":
        title = request.POST.get("title")
        content = request.POST.get("content")
        date_posted = request.POST.get("date_posted") or date.today()

        achievement_id = 'ACH' + str(uuid.uuid4())[:8].upper()  # e.g., 'ACH-1A2B3C4D'

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO exemplary_achievements (achievement_id, alumni_id, title, content, date_posted)
                    VALUES (%s, %s, %s, %s, %s)
                """, (achievement_id, alumni_id, title, content, date_posted))
                conn.commit()

        messages.success(request, "Achievement added successfully.")
        return redirect("profile")  # or 'view_achievements'

    return render(request, "achievements/add_achievement.html")








@login_required
def add_mentorship(request):
    user_id = request.user.id

    # Get mentee_id from student profile
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None

            if role != 'student':
                messages.error(request, "Only students can request mentorship.")
                return redirect('home')

            cursor.execute("SELECT student_id FROM student_profile WHERE user_id = %s", (user_id,))
            result = cursor.fetchone()
            if not result:
                messages.error(request, "Student profile not found.")
                return redirect('home')

            mentee_id = result['student_id']

    if request.method == "POST":
        mentor_id = request.POST.get("mentor_id")
        status = "Pending"
        mentorship_id = 'M_' + str(uuid.uuid4())[:8].upper()
        start_date = date.today()

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO mentorship (mentorship_id, mentor_id, mentee_id, status, start_date)
                    VALUES (%s, %s, %s, %s, %s)
                """, (mentorship_id, mentor_id, mentee_id, status, start_date))
                conn.commit()

        messages.success(request, "Mentorship request sent!")
        return redirect('profile')

    # Fetch list of available mentors
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT alumni_id, full_name, department FROM alumni_profile
            """)
            mentors = cursor.fetchall()
    return render(request, "mentorship/add_mentorship.html", {'mentors': mentors})




@login_required
def send_mentorship_request(request, mentor_id):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Get user's role
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            role = role_result['role'] if role_result else None

            if role != 'student':
                messages.error(request, "Only students can request mentorship.")
                return redirect('home')

            # Get mentee_id
            cursor.execute("SELECT student_id FROM student_profile WHERE user_id = %s", (user_id,))
            result = cursor.fetchone()
            if not result:
                messages.error(request, "Student profile not found.")
                return redirect('home')

            mentee_id = result['student_id']

            # Check if request already exists
            cursor.execute("""
                SELECT * FROM mentorship 
                WHERE mentor_id = %s AND mentee_id = %s AND status = 'Pending'
            """, (mentor_id, mentee_id))
            existing = cursor.fetchone()
            if existing:
                messages.warning(request, "You have already sent a mentorship request to this alumni.")
                return redirect('public_profile_detail', profile_id=mentor_id)

            # Create mentorship request
            mentorship_id = str(uuid.uuid4())[:8].upper()
            status = "Pending"
            start_date = date.today()

            cursor.execute("""
                INSERT INTO mentorship (mentorship_id, mentor_id, mentee_id, status, start_date)
                VALUES (%s, %s, %s, %s, %s)
            """, (mentorship_id, mentor_id, mentee_id, status, start_date))
            conn.commit()

    messages.success(request, "Mentorship request sent!")
    return redirect('public_profile_detail', profile_id=mentor_id)



@login_required
def mentorship_requests_for_alumni(request):
    user_id = request.user.id

    # Get alumni_id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
            role_result = cursor.fetchone()
            if not role_result or role_result['role'] != 'alumni':
                messages.error(request, "Unauthorized.")
                return redirect('home')

            cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
            alumni_result = cursor.fetchone()
            if not alumni_result:
                messages.error(request, "Alumni profile not found.")
                return redirect('home')

            alumni_id = alumni_result['alumni_id']

            cursor.execute("""
                SELECT m.mentorship_id, m.status, m.start_date,
                       s.full_name AS student_name, s.department, s.student_id
                FROM mentorship m
                JOIN student_profile s ON m.mentee_id = s.student_id
                WHERE m.mentor_id = %s AND m.status = 'Pending'
            """, (alumni_id,))
            requests = cursor.fetchall()

    return render(request, 'mentorship/pending_mentorship_requests.html', {'requests': requests})


@login_required
def respond_mentorship_request(request, mentorship_id):
    user_id = request.user.id

    if request.method == "POST":
        action = request.POST.get("action")
        new_status = "Active" if action == "accept" else "Rejected"

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # Optional: verify mentor is authorized
                cursor.execute("SELECT mentor_id FROM mentorship WHERE mentorship_id = %s", (mentorship_id,))
                result = cursor.fetchone()
                if not result:
                    messages.error(request, "Request not found.")
                    return redirect('mentorship_requests_for_alumni')

                cursor.execute("""
                    UPDATE mentorship SET status = %s WHERE mentorship_id = %s
                """, (new_status, mentorship_id))
                conn.commit()

        messages.success(request, f"Mentorship request {new_status.lower()} successfully.")
        return redirect('mentorship_requests_for_alumni')
    return None

@login_required
def end_mentorship(request, mentorship_id):
    user_id = request.user.id

    if request.method == 'POST':
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # Get user role and related ID
                cursor.execute("SELECT role FROM users WHERE user_id = %s", (user_id,))
                role_result = cursor.fetchone()
                role = role_result['role'] if role_result else None

                if role == 'student':
                    cursor.execute("SELECT student_id FROM student_profile WHERE user_id = %s", (user_id,))
                    user_profile = cursor.fetchone()
                    id_column = 'mentee_id'
                    user_id_value = user_profile['student_id']
                elif role == 'alumni':
                    cursor.execute("SELECT alumni_id FROM alumni_profile WHERE user_id = %s", (user_id,))
                    user_profile = cursor.fetchone()
                    id_column = 'mentor_id'
                    user_id_value = user_profile['alumni_id']
                else:
                    messages.error(request, "Unauthorized action.")
                    return redirect('profile')


                # Verify ownership
                cursor.execute(f"""
                    SELECT * FROM mentorship
                    WHERE mentorship_id = %s AND {id_column} = %s AND status = 'Active'
                """, (mentorship_id, user_id_value))

                mentorship = cursor.fetchone()

                if not mentorship:
                    messages.error(request, "You are not authorized to end this mentorship.")
                    return redirect('profile')

                # Mark as completed
                cursor.execute("""
                    UPDATE mentorship SET status = 'Completed' WHERE mentorship_id = %s
                """, (mentorship_id,))
                conn.commit()

                messages.success(request, "Mentorship ended successfully.")

    return redirect('profile')











@login_required
def inbox(request):
    user_id = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Fetch messages where user is sender or receiver
            cursor.execute("""
                            SELECT m.*, s.username AS sender_name, r.username AS receiver_name
                            FROM messages m
                            JOIN (
                                SELECT sender_id, MAX(timestamp) AS latest_time
                                FROM messages
                                WHERE receiver_id = %s
                                GROUP BY sender_id
                            ) latest ON m.sender_id = latest.sender_id AND m.timestamp = latest.latest_time
                            JOIN users s ON m.sender_id = s.user_id
                            JOIN users r ON m.receiver_id = r.user_id
                            WHERE m.receiver_id = %s
                            ORDER BY m.timestamp DESC
                        """, (user_id, user_id))
            messages_ = cursor.fetchall()

    return render(request, 'messages/inbox.html', {'messages_': messages_})


@login_required
def sent_messages(request):
    user_id = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT m.*, u.username AS receiver_name
                FROM messages m
                JOIN users u ON m.receiver_id = u.user_id
                WHERE m.sender_id = %s
                ORDER BY timestamp DESC
            """, (user_id,))
            messages_ = cursor.fetchall()
    return render(request, 'messages/sent.html', {'messages_': messages_})

@login_required
def conversation(request, user_id):
    current_user = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                            UPDATE messages
                            SET is_read = TRUE
                            WHERE receiver_id = %s AND sender_id = %s AND is_read = FALSE
                        """, (current_user, user_id))
            conn.commit()


            cursor.execute("""
                SELECT m.*, sender.username AS sender_name, receiver.username AS receiver_name
                FROM messages m
                JOIN users sender ON m.sender_id = sender.user_id
                JOIN users receiver ON m.receiver_id = receiver.user_id
                WHERE (m.sender_id = %s AND m.receiver_id = %s)
                   OR (m.sender_id = %s AND m.receiver_id = %s)
                ORDER BY m.timestamp 
            """, (current_user, user_id, user_id, current_user))
            thread = cursor.fetchall()
    return render(request, 'messages/conversation.html', {'thread': thread, 'other_id': user_id})



@login_required
def send_message(request, receiver_id):
    if request.method == 'POST':
        sender_id = request.user.id
        content = request.POST.get('content')
        timestamp = timezone.now()
        message_id = str(uuid.uuid4())[:20]

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO messages (message_id, sender_id, receiver_id, content, timestamp)
                    VALUES (%s, %s, %s, %s, %s)
                """, (message_id, sender_id, receiver_id, content, timestamp))
                conn.commit()

        messages.success(request, 'Message sent!')
        return redirect('conversation', user_id=receiver_id)

    return render(request, 'messages/send_message.html', {'receiver_id': receiver_id})


@login_required
def report_message(request, message_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE messages
                SET is_reported = 1
                WHERE message_id = %s
            """, [message_id])
            conn.commit()
    messages.success(request, "Message reported successfully.")
    return redirect('conversation', user_id=request.POST.get('other_id'))








#admin dashboard
@login_required
def admin_dashboard(request):
    return render(request, 'admin/admin_dashboard.html')


def admin_analytics(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Basic counts
            cursor.execute("SELECT COUNT(*) AS total_users FROM users")
            total_users = cursor.fetchone()['total_users']

            cursor.execute("SELECT COUNT(*) AS total_students FROM student_profile WHERE is_graduate=0")
            total_students = cursor.fetchone()['total_students']

            cursor.execute("SELECT COUNT(*) AS total_alumni FROM alumni_profile")
            total_alumni = cursor.fetchone()['total_alumni']

            cursor.execute("SELECT COUNT(*) AS total_admins FROM users WHERE role = 'admin'")
            total_admins = cursor.fetchone()['total_admins']

            cursor.execute("SELECT COUNT(*) AS event_participation FROM event_registration")
            event_participation = cursor.fetchone()['event_participation']

            cursor.execute("SELECT COUNT(DISTINCT event_id) AS total_events FROM event_registration")
            total_events = cursor.fetchone()['total_events']
            avg_participation = round(event_participation / total_events, 2) if total_events else 0

            cursor.execute("SELECT COUNT(*) AS total_jobs FROM job_postings")
            total_jobs = cursor.fetchone()['total_jobs']

            cursor.execute("SELECT COUNT(*) AS active_mentorships FROM mentorship WHERE status = 'active'")
            active_mentorships = cursor.fetchone()['active_mentorships']

            cursor.execute("SELECT COUNT(*) AS completed_mentorships FROM mentorship WHERE status = 'completed'")
            completed_mentorships = cursor.fetchone()['completed_mentorships']

            cursor.execute("SELECT COUNT(*) AS total_gallery_images FROM gallery_images")
            total_gallery_images = cursor.fetchone()['total_gallery_images']

            # Event Participation Trend (last 6 months)
            cursor.execute("""
                SELECT DATE_FORMAT(registration_date, '%Y-%M') AS month, COUNT(*) AS count 
                FROM event_registration 
                GROUP BY month ORDER BY month DESC LIMIT 6
            """)
            participation_data = cursor.fetchall()
            participation_labels = [row['month'] for row in participation_data][::-1]
            participation_counts = [row['count'] for row in participation_data][::-1]

            # Job Posting Trend (last 6 months)
            cursor.execute("""
                SELECT DATE_FORMAT(deadline, '%Y-%M') AS month, COUNT(*) AS count 
                FROM job_postings 
                GROUP BY month ORDER BY month DESC LIMIT 6
            """)
            job_data = cursor.fetchall()
            job_labels = [row['month'] for row in job_data][::-1]
            job_counts = [row['count'] for row in job_data][::-1]

            # Recent activity
            cursor.execute("""
                SELECT u.username AS user, 'Posted Testimonial' AS action, t.date_posted AS timestamp
                FROM testimonials t
                JOIN users u ON u.user_id = t.user_id
                ORDER BY t.date_posted DESC LIMIT 2
            """)
            testimonials = cursor.fetchall()

            cursor.execute("""
                SELECT a.full_name AS user, 'Posted Job' AS action, j.deadline AS timestamp
                FROM job_postings j
                JOIN alumni_profile a ON j.alumni_id = a.alumni_id
                ORDER BY j.deadline DESC LIMIT 2
            """)
            jobs = cursor.fetchall()

            cursor.execute("""
                SELECT u.username AS user, 'Registered for Event' AS action, r.registration_date AS timestamp
                FROM event_registration r
                JOIN users u ON r.user_id = u.user_id
                ORDER BY r.registration_date DESC LIMIT 2
            """)
            registrations = cursor.fetchall()

            recent_activities = testimonials + jobs + registrations
            recent_activities.sort(key=lambda x: x['timestamp'], reverse=True)

            # Additional detailed stats

            # Alumni by department
            cursor.execute("""
                SELECT department, COUNT(*) AS count
                FROM alumni_profile
                GROUP BY department
                ORDER BY count DESC
            """)
            alumni_by_department = cursor.fetchall()

            # Students by department
            cursor.execute("""
                SELECT department, COUNT(*) AS count
                FROM student_profile
                WHERE is_graduate = 0
                GROUP BY department
                ORDER BY count DESC
            """)
            students_by_department = cursor.fetchall()

            # Alumni by batch
            cursor.execute("""
                SELECT batch, COUNT(*) AS count
                FROM alumni_profile
                GROUP BY batch
                ORDER BY batch DESC
            """)
            alumni_by_batch = cursor.fetchall()

            # Students by year
            cursor.execute("""
                SELECT year, COUNT(*) AS count
                FROM student_profile
                WHERE is_graduate = 0
                GROUP BY year
                ORDER BY year ASC
            """)
            students_by_year = cursor.fetchall()

    return render(request, 'admin/analytics.html', {
        'total_users': total_users,
        'total_students': total_students,
        'total_alumni': total_alumni,
        'total_admins': total_admins,
        'event_participation': event_participation,
        'avg_participation': avg_participation,
        'total_jobs': total_jobs,
        'active_mentorships': active_mentorships,
        'completed_mentorships': completed_mentorships,
        'total_gallery_images': total_gallery_images,
        'participation_labels': participation_labels,
        'participation_counts': participation_counts,
        'job_labels': job_labels,
        'job_counts': job_counts,
        'recent_activities': recent_activities,
        'alumni_by_department': alumni_by_department,
        'students_by_department': students_by_department,
        'alumni_by_batch': alumni_by_batch,
        'students_by_year': students_by_year,
    })



@login_required
def manage_notifications(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM admin_notifications")
            notifications = cursor.fetchall()
    return render(request, 'admin/manage_notifications.html', {'notifications': notifications})


@login_required
def manage_events(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM events")
            events = cursor.fetchall()
    return render(request, 'admin/manage_events.html', {'events': events})


@login_required
def manage_mentorships(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT m.*, a1.full_name AS mentor_name, s.full_name AS mentee_name
                FROM mentorship m
                LEFT JOIN alumni_profile a1 ON m.mentor_id = a1.alumni_id
                LEFT JOIN student_profile s ON m.mentee_id = s.student_id
            """)
            mentorships = cursor.fetchall()
    return render(request, 'admin/manage_mentorships.html', {'mentorships': mentorships})


@login_required
def moderate_messages(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT m.*, s1.username AS sender_name, s2.username AS receiver_name
                FROM messages m
                LEFT JOIN users s1 ON m.sender_id = s1.user_id
                LEFT JOIN users s2 ON m.receiver_id = s2.user_id
                WHERE m.is_reported = 1
                ORDER BY m.timestamp DESC
            """)
            reported_messages = cursor.fetchall()
    return render(request, 'admin/moderate_messages.html', {'messages_': reported_messages})

@login_required
def dismiss_report(request, message_id):
    if request.method == "POST":
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("UPDATE messages SET is_reported = 0 WHERE message_id = %s", [message_id])
                conn.commit()
        messages.success(request, "Message marked as safe.")
    return redirect('moderate_messages')

@login_required
def delete_message(request, message_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM messages WHERE message_id = %s", (message_id,))
            conn.commit()
    return redirect('admin_dashboard')

def warn_user(request, user_id):
    admin_id = request.user.id
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO messages (message_id, sender_id, receiver_id, content, timestamp, is_read)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (
                str(uuid.uuid4())[:20],
                admin_id,
                user_id,
                "Your message was reported. Please follow community guidelines.",
                timezone.now(),
                0
            ))
            conn.commit()
    messages.success(request, "Warning sent to user.")
    return redirect('moderate_messages')




@login_required
def add_notification(request):
    if request.method == 'POST':
        title = request.POST.get('title')
        content = request.POST.get('content')
        notification_id = str(uuid.uuid4())[:20]
        created_at = now()

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute(
                    """
                    INSERT INTO admin_notifications (notification_id, title, content, created_at)
                    VALUES (%s, %s, %s, %s)
                    """,
                    (notification_id, title, content, created_at)
                )
                conn.commit()
        return redirect('admin_dashboard')

    return render(request, 'admin/add_notification.html')

@login_required
def edit_notification(request, notification_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if request.method == 'POST':
                title = request.POST['title']
                content = request.POST['content']
                cursor.execute("""
                    UPDATE admin_notifications SET title = %s, content = %s WHERE notification_id = %s
                """, [title, content, notification_id])
                conn.commit()
                messages.success(request, 'Notification updated successfully.')
                return redirect('admin_dashboard')
            else:
                cursor.execute("SELECT * FROM admin_notifications WHERE notification_id = %s", [notification_id])
                notif = cursor.fetchone()
    return render(request, 'admin/edit_notification.html', {'notification': notif})



@login_required
def delete_notification(request, notification_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM admin_notifications WHERE notification_id = %s", (notification_id,))
            conn.commit()
    return redirect('admin_dashboard')




@login_required
def add_event(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        date = request.POST.get('date')
        location = request.POST.get('location')
        description = request.POST.get('description')
        image = request.FILES.get('image')

        if name and date and location and description:
            event_id = 'E_' + str(uuid.uuid4())[:8]
            image_path = None

            if image:
                image_filename = f"{uuid.uuid4().hex}_{image.name}"
                save_path = os.path.join(settings.MEDIA_ROOT, 'events', image_filename)
                os.makedirs(os.path.dirname(save_path), exist_ok=True)
                with open(save_path, 'wb+') as f:
                    for chunk in image.chunks():
                        f.write(chunk)
                image_path = f'events/{image_filename}'

            with get_db_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        "INSERT INTO events (event_id, title, date, description, location, image) VALUES (%s, %s, %s, %s, %s, %s)",
                        (event_id, name, date, description, location, image_path)
                    )
                    conn.commit()
            return redirect('admin_dashboard')
        else:
            return render(request, 'admin/add_event.html', {
                'error': 'All fields are required.'
            })
    return render(request, 'admin/add_event.html')


@login_required
def edit_event(request, event_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if request.method == 'POST':
                name = request.POST['title']
                date = request.POST['date']
                description = request.POST['description']
                location = request.POST['location']
                image = request.FILES.get('image')
                image_path = None

                if image:
                    image_filename = f"{uuid.uuid4().hex}_{image.name}"
                    save_path = os.path.join(settings.MEDIA_ROOT, 'events', image_filename)
                    os.makedirs(os.path.dirname(save_path), exist_ok=True)
                    with open(save_path, 'wb+') as f:
                        for chunk in image.chunks():
                            f.write(chunk)
                    image_path = f'events/{image_filename}'

                if image_path:
                    cursor.execute("""
                        UPDATE events SET title = %s, date = %s, description = %s, location = %s, image = %s
                        WHERE event_id = %s
                    """, [name, date, description, location, image_path, event_id])
                else:
                    cursor.execute("""
                        UPDATE events SET title = %s, date = %s, description = %s, location = %s
                        WHERE event_id = %s
                    """, [name, date, description, location, event_id])
                conn.commit()
                messages.success(request, 'Event updated successfully.')
                return redirect('admin_dashboard')
            else:
                cursor.execute("SELECT * FROM events WHERE event_id = %s", [event_id])
                event = cursor.fetchone()
    return render(request, 'admin/edit_event.html', {'event': event})




@login_required
def delete_event(request, event_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM events WHERE event_id = %s", (event_id,))
            conn.commit()
    return redirect('admin_dashboard')






@login_required
def update_mentorship_status(request, mentorship_id):
    if request.method == 'POST':
        new_status = request.POST.get('status')
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("UPDATE mentorship SET status = %s WHERE mentorship_id = %s", (new_status, mentorship_id))
                conn.commit()
    return redirect('admin_dashboard')











@login_required
def submit_testimonial(request):
    if request.method == "POST":
        content = request.POST.get("content")
        user_id = request.user.id
        testimonial_id = 'T_' + str(uuid.uuid4())[:8].upper()


        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO Testimonials (testimonial_id, user_id, content, date_posted, approved)
                    VALUES (%s, %s, %s, %s, %s)
                """, (testimonial_id, user_id, content, date.today(), 0))
                conn.commit()
        return redirect("profile")
    return render(request, "testimonials/add_testimonial.html")


@login_required
def edit_testimonial(request, testimonial_id):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if request.method == 'POST':
                new_content = request.POST['content']
                cursor.execute("""
                    UPDATE testimonials
                    SET content = %s, date_posted = CURDATE(), approved = 0
                    WHERE testimonial_id = %s AND user_id = %s
                """, (new_content, testimonial_id, user_id))
                conn.commit()
                messages.success(request, "Testimonial updated and sent for approval again.")
                return redirect('profile')

            # GET request: fetch current testimonial
            cursor.execute("""
                SELECT content FROM testimonials
                WHERE testimonial_id = %s AND user_id = %s AND approved = 1
            """, (testimonial_id, user_id))
            testimonial = cursor.fetchone()
            print(testimonial)

    if testimonial:
        return render(request, 'testimonials/edit_testimonial.html', {'testimonial_id': testimonial_id, 'testimonial': testimonial})
    else:
        return HttpResponse("Testimonial not found or access denied.")


@login_required
def delete_testimonial(request, testimonial_id):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                DELETE FROM testimonials
                WHERE testimonial_id = %s AND user_id = %s
            """, (testimonial_id, user_id))
            conn.commit()

    messages.success(request, "Testimonial deleted.")
    return redirect('profile')




def manage_testimonials(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if request.method == "POST":
                action = request.POST.get("action")
                testimonial_id = request.POST.get("testimonial_id")

                if action == "approve":
                    cursor.execute("UPDATE Testimonials SET approved = 1 WHERE testimonial_id = %s", (testimonial_id,))
                elif action == "delete":
                    cursor.execute("DELETE FROM Testimonials WHERE testimonial_id = %s", (testimonial_id,))
                conn.commit()

            cursor.execute("""
                SELECT t.*, u.username
                FROM Testimonials t
                JOIN Users u ON t.user_id = u.user_id
                ORDER BY t.date_posted DESC
            """)
            testimonials = cursor.fetchall()

    return render(request, "admin/manage_testimonials.html", {"testimonials": testimonials})


def testimonials_page(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT 
                    t.content, 
                    t.date_posted, 
                    CASE 
                        WHEN ap.full_name IS NOT NULL THEN ap.full_name
                        ELSE sp.full_name
                    END AS full_name,
                    u.role
                FROM testimonials t
                JOIN users u ON t.user_id = u.user_id
                LEFT JOIN alumni_profile ap ON u.user_id = ap.user_id
                LEFT JOIN student_profile sp ON u.user_id = sp.user_id
                WHERE t.approved = 1
                ORDER BY t.date_posted DESC
            """)
            testimonials = cursor.fetchall()

    return render(request, "testimonials/view_testimonials.html", {
        "testimonials": testimonials
    })










def contact_form(request):
    success = False

    if request.method == 'POST':
        name = request.POST['name']
        email = request.POST['email']
        message = request.POST['message']
        contact_id = 'CT' + uuid.uuid4().hex[:6]
        submitted_at = now()

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO contact_messages (contact_id, name, email, message, submitted_at)
                    VALUES (%s, %s, %s, %s, %s)
                """, (contact_id, name, email, message, submitted_at))
                conn.commit()
                success = True

    return render(request, 'contact_form.html', {'success': success})




@login_required
def view_contact_messages(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM contact_messages ORDER BY submitted_at DESC")
            messages_ = cursor.fetchall()

    return render(request, 'admin/contact_messages.html', {'messages_': messages_})











@login_required
def upload_gallery_image(request):
    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        image = request.FILES.get('image')

        if title and image:
            image_id = str(uuid.uuid4())[:20]
            image_filename = f"{uuid.uuid4().hex}_{image.name}"
            save_path = os.path.join(settings.MEDIA_ROOT, 'gallery', image_filename)
            os.makedirs(os.path.dirname(save_path), exist_ok=True)

            with open(save_path, 'wb+') as f:
                for chunk in image.chunks():
                    f.write(chunk)

            image_path = f'gallery/{image_filename}'

            with get_db_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        INSERT INTO gallery_images (image_id, title, description, image_path, uploaded_at, user_id)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (image_id, title, description, image_path, timezone.now(), request.user.id))
                    conn.commit()

            return redirect('gallery')
        else:
            return render(request, 'gallery/upload_image.html', {
                'error': 'Title and image are required.'
            })
    return render(request, 'gallery/upload_image.html')



def gallery(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM gallery_images ORDER BY uploaded_at DESC")
            images = cursor.fetchall()
    return render(request, 'gallery/gallery.html', {'images': images})


@login_required
def edit_gallery_item(request, gallery_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Fetch the item
            cursor.execute("SELECT * FROM gallery_images WHERE image_id = %s", [gallery_id])
            item = cursor.fetchone()

            if not item:
                messages.error(request, "Gallery item not found.")
                return redirect('gallery')

            # Check permission
            if item['user_id'] != request.user.id and not request.user.is_staff:
                messages.error(request, "You do not have permission to edit this item.")
                return redirect('gallery')

            if request.method == 'POST':
                title = request.POST.get('title')
                description = request.POST.get('description')
                cursor.execute("""
                    UPDATE gallery_images SET title=%s, description=%s WHERE image_id=%s
                """, (title, description, gallery_id))
                conn.commit()
                messages.success(request, "Gallery item updated.")
                return redirect('gallery')

    return render(request, 'gallery/edit_gallery_item.html', {'item': item})


@login_required
def delete_gallery_item(request, gallery_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT image_path, user_id FROM gallery_images WHERE image_id = %s", [gallery_id])
            item = cursor.fetchone()

            if not item:
                messages.error(request, "Gallery item not found.")
                return redirect('gallery')

            if item['user_id'] != request.user.id and not request.user.is_staff:
                messages.error(request, "You do not have permission to delete this item.")
                return redirect('gallery')

            # Remove image file
            image_path = os.path.join(settings.MEDIA_ROOT, item['image_path'])
            if os.path.exists(image_path):
                os.remove(image_path)

            cursor.execute("DELETE FROM gallery_images WHERE image_id=%s", [gallery_id])
            conn.commit()
            messages.success(request, "Gallery item deleted.")

    return redirect('gallery')









from django.contrib.admin.views.decorators import staff_member_required

@staff_member_required
def pending_admins(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT user_id FROM users WHERE role = 'admin'")
            admin_ids = [row['user_id'] for row in cursor.fetchall()]
    unapproved_admins = User.objects.filter(id__in=admin_ids, is_staff=False)
    return render(request, 'admin/pending_admins.html', {'admins': unapproved_admins})

@staff_member_required
def approve_admin(request, user_id):
    user = User.objects.get(id=user_id)
    user.is_staff = True
    user.save()
    messages.success(request, f"{user.username} has been approved as admin.")
    return redirect('pending_admins')







def graduate_student(request, student_id):
    if request.method == 'POST':
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("UPDATE student_profile SET is_graduate = TRUE WHERE student_id = %s", [student_id])
                conn.commit()
        messages.success(request, "Student marked as graduated.")
    return redirect('home')








def notifications_page(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM admin_notifications ORDER BY created_at DESC")
            notifications = cursor.fetchall()
    return render(request, 'notifications/notification_page.html', {'notifications': notifications})





@login_required
def manage_users(request):
    if not request.user.is_staff:
        return HttpResponseForbidden()

    search_query = request.GET.get('search', '')

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if search_query:
                cursor.execute("""
                    SELECT user_id, username, email, role, is_active 
                    FROM users 
                    WHERE username LIKE %s
                """, [f'%{search_query}%'])
            else:
                cursor.execute("SELECT user_id, username, email, role, is_active FROM users")
            users = cursor.fetchall()

    return render(request, 'admin/manage_users.html', {
        'users': users,
        'search_query': search_query
    })


@login_required
def toggle_user_status(request, user_id):
    if not request.user.is_staff:
        return HttpResponseForbidden()

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Get current status
            cursor.execute("SELECT is_active FROM users WHERE user_id = %s", [user_id])
            current = cursor.fetchone()
            new_status = 0 if current['is_active'] else 1

            cursor.execute("UPDATE users SET is_active = %s WHERE user_id = %s", [new_status, user_id])
            conn.commit()

    return redirect('manage_users')








@login_required
def add_student_draft(request):
    user_id = request.user.id

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Fetch student_id using user_id
            cursor.execute("SELECT student_id FROM student_profile WHERE user_id = %s", [user_id])
            result = cursor.fetchone()
            if not result:
                return HttpResponse("Student profile not found.", status=404)

            student_id = result['student_id']

            if request.method == 'POST':
                draft_id = 'D' + str(uuid.uuid4().hex[:8])
                project_title = request.POST['project_title']
                project_desc = request.POST['project_desc']
                research_paper = request.POST['research_paper']
                thesis_summary = request.POST['thesis_summary']
                club_details = request.POST['club_details']

                cursor.execute("""
                    INSERT INTO student_drafts (
                        draft_id, student_id, project_title, project_desc, research_paper, thesis_summary, club_details
                    ) VALUES (%s, %s, %s, %s, %s, %s, %s)
                """, [draft_id, student_id, project_title, project_desc, research_paper, thesis_summary, club_details])
                conn.commit()

                return redirect('profile')

    return render(request, 'drafts/add_draft.html', {
        'student_id': student_id
    })


@login_required
def edit_student_draft(request, draft_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            if request.method == 'POST':
                # Updating only the provided fields
                update_fields = []
                update_values = []

                if 'project_title' in request.POST:
                    update_fields.append("project_title = %s")
                    update_values.append(request.POST['project_title'])

                if 'project_desc' in request.POST:
                    update_fields.append("project_desc = %s")
                    update_values.append(request.POST['project_desc'])

                if 'research_paper' in request.POST:
                    update_fields.append("research_paper = %s")
                    update_values.append(request.POST['research_paper'])

                if 'thesis_summary' in request.POST:
                    update_fields.append("thesis_summary = %s")
                    update_values.append(request.POST['thesis_summary'])

                if 'club_details' in request.POST:
                    update_fields.append("club_details = %s")
                    update_values.append(request.POST['club_details'])

                update_values.append(draft_id)

                # Dynamic SQL to update only the modified fields
                update_query = f"""
                    UPDATE student_drafts
                    SET {', '.join(update_fields)}
                    WHERE draft_id = %s
                """
                cursor.execute(update_query, update_values)
                conn.commit()

                return redirect('profile')

            # Load existing draft
            cursor.execute("SELECT * FROM student_drafts WHERE draft_id = %s", [draft_id])
            draft = cursor.fetchone()

    return render(request, 'drafts/edit_draft.html', {'draft': draft})


@login_required
def delete_student_draft(request, draft_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Get student_id before deleting to redirect properly
            cursor.execute("SELECT student_id FROM student_drafts WHERE draft_id = %s", [draft_id])
            result = cursor.fetchone()
            if not result:
                return HttpResponse("Draft not found.", status=404)

            student_id = result['student_id']

            # Delete the draft
            cursor.execute("DELETE FROM student_drafts WHERE draft_id = %s", [draft_id])
            conn.commit()

    return redirect('profile')








def our_community_view(request):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT oc.*, a.full_name, a.picture
                FROM our_community oc
                JOIN alumni_profile a ON oc.alumni_id = a.alumni_id
                ORDER BY oc.start_date DESC
            """)
            leaders = cursor.fetchall()

    return render(request, 'community/our_community.html', {
        'leaders': leaders
    })

@login_required
def add_community_role(request):
    if not request.user.is_staff:
        return HttpResponseForbidden()

    if request.method == 'POST':
        role_id = 'R' + str(uuid.uuid4().hex[:8])
        alumni_id = request.POST['alumni_id']
        role_title = request.POST['role_title']
        start_date = request.POST['start_date']
        end_date = request.POST['end_date']
        description = request.POST['description']

        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO our_community (role_id, alumni_id, role_title, start_date, end_date, description)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, [role_id, alumni_id, role_title, start_date, end_date, description])
                conn.commit()

        return redirect('our_community')

    # If you want to list alumni to choose from:
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT alumni_id, full_name FROM alumni_profile")
            alumni_list = cursor.fetchall()

    return render(request, 'community/add_role.html', {
        'alumni_list': alumni_list
    })

@login_required
def edit_community_role(request, role_id):
    if not request.user.is_staff:
        return HttpResponseForbidden()

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Fetch role info
            cursor.execute("""
                SELECT * FROM our_community WHERE role_id = %s
            """, [role_id])
            role = cursor.fetchone()

            # Fetch alumni list
            cursor.execute("""
                SELECT alumni_id, full_name FROM alumni_profile
            """)
            alumni_list = cursor.fetchall()

            if request.method == 'POST':
                alumni_id = request.POST['alumni_id']
                role_title = request.POST['role_title']
                start_date = request.POST['start_date']
                end_date = request.POST['end_date']
                description = request.POST['description']

                cursor.execute("""
                    UPDATE our_community
                    SET alumni_id = %s, role_title = %s, start_date = %s, end_date = %s, description = %s
                    WHERE role_id = %s
                """, [alumni_id, role_title, start_date, end_date, description, role_id])
                conn.commit()

                return redirect('our_community')
            role_titles = ['President', 'Vice President', 'General Secretary', 'Editor']

    return render(request, 'community/edit_role.html', {
        'role': role,
        'alumni_list': alumni_list,
        'role_titles': role_titles
    })


@login_required
def delete_community_role(request, role_id):
    if not request.user.is_staff:
        return HttpResponseForbidden()

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM our_community WHERE role_id = %s", [role_id])
            conn.commit()

    return redirect('our_community')











@login_required
def global_search(request):
    query = request.GET.get('q', '').strip()
    results = {}

    if query:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:

                # Alumni
                cursor.execute("""
                    SELECT full_name, department, job_title, company 
                    FROM alumni_profile 
                    WHERE full_name LIKE %s OR department LIKE %s 
                       OR job_title LIKE %s OR company LIKE %s
                """, [f'%{query}%'] * 4)
                results['alumni'] = cursor.fetchall()

                # Students
                cursor.execute("""
                    SELECT full_name, department, interests 
                    FROM student_profile 
                    WHERE full_name LIKE %s OR department LIKE %s OR interests LIKE %s
                """, [f'%{query}%'] * 3)
                results['students'] = cursor.fetchall()

                # Events
                cursor.execute("""
                    SELECT title, description, location 
                    FROM events 
                    WHERE title LIKE %s OR description LIKE %s OR location LIKE %s
                """, [f'%{query}%'] * 3)
                results['events'] = cursor.fetchall()

                # Achievements
                cursor.execute("""
                    SELECT title, content 
                    FROM exemplary_achievements 
                    WHERE title LIKE %s OR content LIKE %s
                """, [f'%{query}%'] * 2)
                results['achievements'] = cursor.fetchall()

                # Jobs
                cursor.execute("""
                    SELECT title, company, description 
                    FROM job_postings 
                    WHERE title LIKE %s OR company LIKE %s OR description LIKE %s
                """, [f'%{query}%'] * 3)
                results['jobs'] = cursor.fetchall()

                # Testimonials
                cursor.execute("""
                    SELECT content 
                    FROM testimonials 
                    WHERE content LIKE %s AND approved = 1
                """, [f'%{query}%'])
                results['testimonials'] = cursor.fetchall()

                # Gallery
                cursor.execute("""
                    SELECT title, description 
                    FROM gallery_images 
                    WHERE title LIKE %s OR description LIKE %s
                """, [f'%{query}%'] * 2)
                results['gallery'] = cursor.fetchall()

                # Drafts
                cursor.execute("""
                    SELECT project_title, project_desc, research_paper, thesis_summary, club_details 
                    FROM student_drafts 
                    WHERE project_title LIKE %s OR project_desc LIKE %s 
                       OR research_paper LIKE %s OR thesis_summary LIKE %s OR club_details LIKE %s
                """, [f'%{query}%'] * 5)
                results['drafts'] = cursor.fetchall()

    return render(request, 'search/search_results.html', {
        'query': query,
        'results': results
    })









from django.contrib.auth.decorators import login_required
from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.template.loader import get_template
from xhtml2pdf import pisa
from .db import get_db_connection

@login_required
def generate_cv_pdf(request, student_id):
    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            # Fetch student profile
            cursor.execute("SELECT * FROM student_profile WHERE student_id = %s", [student_id])
            student = cursor.fetchone()

            if not student:
                return HttpResponse("Student not found", status=404)

            # Fetch student drafts
            cursor.execute("SELECT * FROM student_drafts WHERE student_id = %s", [student_id])
            drafts = cursor.fetchall()

    # Render to PDF
    template = get_template("pdf/student_cv.html")
    html = template.render({
        "student": student,
        "drafts": drafts
    })

    response = HttpResponse(content_type="application/pdf")
    response["Content-Disposition"] = f'attachment; filename="{student["full_name"]}_CV.pdf"'

    pisa_status = pisa.CreatePDF(html, dest=response)
    if pisa_status.err:
        return HttpResponse("Error generating PDF", status=500)

    return response







@login_required
def recommend(request):
    if request.user.is_staff:
        return HttpResponseForbidden("Admins do not receive alumni recommendations.")

    with get_db_connection() as conn:
        with conn.cursor() as cursor:
            #Get student_id, department, and interests
            cursor.execute("""
                SELECT s.student_id, s.department, s.interests
                FROM student_profile s
                JOIN users u ON s.user_id = u.user_id
                WHERE u.user_id = %s
            """, [request.user.id])

            student = cursor.fetchone()
            if not student:
                return HttpResponseForbidden("No student profile found.")

            student_id = student['student_id']
            department = student['department']
            interests = student['interests'] or ""
            interest_keywords = [kw.strip().lower() for kw in interests.split(',')]

            # Fetch recommended alumni
            cursor.execute("""
                SELECT 
                    ap.alumni_id, 
                    ap.full_name, 
                    ap.job_title, 
                    ap.company, 
                    ap.linkedin, 
                    ap.picture,
                    ap.department,
                    COUNT(DISTINCT CASE WHEN m.status IN ('active', 'completed') THEN m.mentorship_id END) AS mentorship_count
                FROM alumni_profile ap
                JOIN users au ON ap.user_id = au.user_id
                LEFT JOIN mentorship m ON ap.alumni_id = m.mentor_id
                LEFT JOIN student_profile ms ON m.mentee_id = ms.student_id
                LEFT JOIN exemplary_achievements ea ON ap.alumni_id = ea.alumni_id
                LEFT JOIN job_postings jp ON ap.alumni_id = jp.alumni_id
                WHERE (
                    (ms.department = %s AND m.status IN ('active', 'completed'))
                    OR (
                        LOWER(ea.content) LIKE CONCAT('%%', LOWER(%s), '%%')
                        OR LOWER(jp.title) LIKE CONCAT('%%', LOWER(%s), '%%')
                        OR LOWER(jp.description) LIKE CONCAT('%%', LOWER(%s), '%%')
                        OR LOWER(jp.description) LIKE CONCAT('%%', LOWER(%s), '%%') 
                    )
                )
                GROUP BY ap.alumni_id, ap.full_name, ap.job_title, ap.company, ap.linkedin, ap.picture, ap.department
                ORDER BY 
                    CASE WHEN ap.department = %s THEN 0 ELSE 1 END, 
                    mentorship_count DESC,
                    ap.full_name ASC
            """, [department, interests, interests, interests, department, department])

            recommended_alumni = cursor.fetchall()

            # Alumni based on interest keywords only
            interest_keywords = [i.strip() for i in interests.split(',')]
            interest_conditions = " OR ".join([
                "(LOWER(ea.content) LIKE CONCAT('%%', LOWER(%s), '%%') OR " +
                "LOWER(jp.title) LIKE CONCAT('%%', LOWER(%s), '%%') OR " +
                "LOWER(jp.description) LIKE CONCAT('%%', LOWER(%s), '%%'))"
                for _ in interest_keywords
            ])
            sql = f"""
                SELECT 
                    ap.alumni_id, 
                    ap.full_name, 
                    ap.job_title, 
                    ap.company, 
                    ap.linkedin, 
                    ap.picture,
                    ap.department
                FROM alumni_profile ap
                JOIN users au ON ap.user_id = au.user_id
                LEFT JOIN exemplary_achievements ea ON ap.alumni_id = ea.alumni_id
                LEFT JOIN job_postings jp ON ap.alumni_id = jp.alumni_id
                WHERE {interest_conditions}
                GROUP BY ap.alumni_id, ap.full_name, ap.job_title, ap.company, ap.linkedin, ap.picture, ap.department
                ORDER BY ap.full_name
            """
            args = []
            for kw in interest_keywords:
                args.extend([kw, kw, kw])
            cursor.execute(sql, args)
            interest_based_results = cursor.fetchall()

            # Recommend events
            cursor.execute("""
                SELECT 
                    e.event_id,
                    e.title,
                    e.description,
                    e.date,
                    e.location,
                    e.image,
                    COUNT(DISTINCT er.user_id) AS total_registrations,
                    COUNT(DISTINCT CASE 
                        WHEN sp.department = %s OR ap.department = %s THEN er.user_id
                    END) AS same_dept_registrations,

                    (
                        LENGTH(e.description) - LENGTH(REPLACE(LOWER(e.description), LOWER(%s), ''))
                    ) AS interest_match_score

                FROM events e
                JOIN event_registration er ON e.event_id = er.event_id
                JOIN users u ON er.user_id = u.user_id
                LEFT JOIN student_profile sp ON u.user_id = sp.user_id
                LEFT JOIN alumni_profile ap ON u.user_id = ap.user_id

                WHERE e.date >= CURRENT_DATE()

                GROUP BY e.event_id, e.title, e.description, e.date, e.location, e.image

                ORDER BY 
                    same_dept_registrations DESC,
                    interest_match_score DESC,
                    e.date ASC

                LIMIT 10
            """, [department, department, interests])

            recommended_events = cursor.fetchall()

            for event in recommended_events:
                total = event['total_registrations']
                same_dept = event['same_dept_registrations']
                event['match_percentage'] = round((same_dept / total) * 100, 1) if total > 0 else 0



            # Events based on interests
            event_interest_conditions = " OR ".join([
                "LOWER(e.title) LIKE CONCAT('%%', LOWER(%s), '%%') OR LOWER(e.description) LIKE CONCAT('%%', LOWER(%s), '%%')"
                for _ in interest_keywords
            ])
            event_sql = f"""
                            SELECT e.event_id, e.title, e.description, e.date, e.location, e.image
                            FROM events e
                            WHERE e.date >= CURDATE()
                              AND ({event_interest_conditions})
                            ORDER BY e.date ASC
                        """
            event_args = []
            for kw in interest_keywords:
                event_args.extend([kw, kw])
            cursor.execute(event_sql, event_args)
            interest_based_events = cursor.fetchall()

            # Job Recommendation (based on interests OR same department)
            cursor.execute("""
                            SELECT jp.job_id, jp.title, jp.company, jp.description, jp.deadline
                            FROM job_postings jp
                            JOIN alumni_profile ap ON jp.alumni_id = ap.alumni_id
                            WHERE jp.deadline >= CURDATE()
                              AND (
                                  ap.department = %s
                                  OR LOWER(jp.description) LIKE CONCAT('%%', LOWER(%s), '%%')
                                  OR LOWER(jp.title) LIKE CONCAT('%%', LOWER(%s), '%%')
                              )
                            ORDER BY jp.deadline ASC
                        """, [department, interests, interests])
            recommended_jobs = cursor.fetchall()

            # Jobs based on interests
            job_interest_conditions = " OR ".join([
                "LOWER(jp.title) LIKE CONCAT('%%', LOWER(%s), '%%') OR LOWER(jp.description) LIKE CONCAT('%%', LOWER(%s), '%%')"
                for _ in interest_keywords
            ])
            job_sql = f"""
                            SELECT jp.job_id, jp.title, jp.company, jp.description, jp.deadline
                            FROM job_postings jp
                            WHERE jp.deadline >= CURDATE()
                              AND ({job_interest_conditions})
                            ORDER BY jp.deadline ASC
                        """
            job_args = []
            for kw in interest_keywords:
                job_args.extend([kw, kw])
            cursor.execute(job_sql, job_args)
            interest_based_jobs = cursor.fetchall()

    return render(request, 'recommendations/recommend.html', {
        'recommended_alumni': recommended_alumni,
        'interest_based_recommended_alumni': interest_based_results,
        'recommended_events': recommended_events,
        'recommended_jobs': recommended_jobs,
        'student_department': department,
        'interest_based_events': interest_based_events,
        'interest_based_jobs': interest_based_jobs,
    })









