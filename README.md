# 🎓 AlumniVerse

AlumniVerse is a full-featured alumni management web application developed as part of a university course project. It is designed to help institutions connect students with alumni, manage events, share opportunities, and foster ongoing engagement in the academic community.

---

## 🔧 Tech Stack

- **Backend**: Django (using raw SQL instead of the ORM)
- **Database**: MySQL
- **Frontend**: HTML, CSS, JavaScript
- **Auth & Sessions**: Django built-in tables like `auth_user`, `django_session`, etc.

---

## 📌 Key Features

- Role-based user system (admin, alumni, student)
- Alumni and student profile management
- Admin dashboard for managing:
  - Analytics DashBoard
  - Events
  - Notifications
  - Testimonials
  - Mentorships
  - Reported Messages
  - Admin registration approval
  - Managing user accounts(activate/deactivate)
  - Messages and contact forms
- Event registration and viewer
- Messaging system with inbox and conversation views
- Alumni mentorship request handling
- Global search
- recommendations for students
- Resume (CV) PDF generation
- Student draft posts and "Our Community" alumni highlights
- Gallery and media management
- alumni Jobs, testimonials and achievements posting

---

## 💡 About the Project

- Built using **raw SQL queries** in Django to interact with a custom MySQL schema.
- Django ORM was intentionally **not used** for core database operations, allowing full manual control over SQL.
- Integrated with Django's core tables like `auth_user` for authentication and `django_session` for session handling.
- MySQL database schema and sample data are included in the `mysql files/` directory.

---
