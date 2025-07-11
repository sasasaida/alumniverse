import os

from django.db import models
from django.contrib.auth.models import User
from django.core.validators import RegexValidator


class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(
        max_length=20,
        choices=[('student', 'Student'), ('alumni', 'Alumni'), ('admin', 'Admin')]
    )

    def __str__(self):
        return f"{self.user.username} - {self.role}"

class AlumniProfile(models.Model):
    alumni_id = models.CharField(max_length=20, primary_key=True)
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    full_name = models.CharField(max_length=100)
    batch = models.CharField(max_length=10)
    department = models.CharField(max_length=50)
    job_title = models.CharField(max_length=100, blank=True, null=True)
    company = models.CharField(max_length=100, blank=True, null=True)
    linkedin = models.CharField(
        max_length=100,
        validators=[RegexValidator(regex=r'^https://www\.linkedin\.com/.*$', message='Invalid LinkedIn URL')],
        blank=True,
        null=True
    )
    bio = models.TextField(blank=True, null=True)
    picture = models.ImageField(upload_to='profiles/alumni/', blank=True, null=True)

    def __str__(self):
        return self.full_name

    def save(self, *args, **kwargs):
        # Get the existing instance from the database
        try:
            old_instance = AlumniProfile.objects.get(pk=self.pk)
            old_picture = old_instance.picture
        except AlumniProfile.DoesNotExist:
            old_picture = None

        # If there's a new picture and it's different from the old one
        if self.picture and self.picture != old_picture:
            # Delete the old picture file if it exists
            if old_picture and os.path.isfile(old_picture.path):
                os.remove(old_picture.path)

        super().save(*args, **kwargs)


class StudentProfile(models.Model):
    student_id = models.CharField(max_length=20, primary_key=True)
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    full_name = models.CharField(max_length=100)
    department = models.CharField(max_length=50)
    year = models.PositiveIntegerField()
    interests = models.TextField(blank=True, null=True)
    picture = models.ImageField(upload_to='profiles/students/', blank=True, null=True)

    def __str__(self):
        return self.full_name

    def save(self, *args, **kwargs):
        # Get the existing instance from the database
        try:
            old_instance = StudentProfile.objects.get(pk=self.pk)
            old_picture = old_instance.picture
        except StudentProfile.DoesNotExist:
            old_picture = None

        # If there's a new picture and it's different from the old one
        if self.picture and self.picture != old_picture:
            # Delete the old picture file if it exists
            if old_picture and os.path.isfile(old_picture.path):
                os.remove(old_picture.path)

        super().save(*args, **kwargs)


class Event(models.Model):
    event_id = models.CharField(max_length=20, primary_key=True)
    title = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    date = models.DateField()
    location = models.CharField(max_length=100)

    def __str__(self):
        return self.title


class EventRegistration(models.Model):
    registration_id = models.CharField(max_length=20, primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    event = models.ForeignKey(Event, on_delete=models.CASCADE)
    registration_date = models.DateField()

    def __str__(self):
        return f"{self.user.username} - {self.event.title}"


class ExemplaryAchievement(models.Model):
    achievement_id = models.CharField(max_length=20, primary_key=True)
    alumni = models.ForeignKey(AlumniProfile, on_delete=models.CASCADE)
    title = models.CharField(max_length=100)
    content = models.TextField()
    date_posted = models.DateField()

    def __str__(self):
        return self.title


class JobPosting(models.Model):
    job_id = models.CharField(max_length=20, primary_key=True)
    alumni = models.ForeignKey(AlumniProfile, on_delete=models.CASCADE)
    title = models.CharField(max_length=100)
    company = models.CharField(max_length=100)
    description = models.TextField()
    deadline = models.DateField()

    def __str__(self):
        return self.title


class Mentorship(models.Model):
    mentorship_id = models.CharField(max_length=20, primary_key=True)
    mentor = models.ForeignKey(AlumniProfile, on_delete=models.CASCADE)
    mentee = models.ForeignKey(StudentProfile, on_delete=models.CASCADE)
    status = models.CharField(
        max_length=20,
        choices=[('pending', 'Pending'), ('active', 'Active'), ('completed', 'Completed'), ('rejected', 'Rejected')]
    )
    start_date = models.DateField()

    def __str__(self):
        return f"{self.mentor.full_name} - {self.mentee.full_name}"


class Message(models.Model):
    message_id = models.CharField(max_length=20, primary_key=True)
    sender = models.ForeignKey(User, related_name='sent_messages', on_delete=models.CASCADE)
    receiver = models.ForeignKey(User, related_name='received_messages', on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"From {self.sender.username} to {self.receiver.username}"


class Testimonial(models.Model):
    testimonial_id = models.CharField(max_length=20, primary_key=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    content = models.TextField()
    date_posted = models.DateField()

    def __str__(self):
        return f"By {self.user.username}"


class AdminNotification(models.Model):
    notification_id = models.CharField(max_length=20, primary_key=True)
    title = models.CharField(max_length=100)
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.title


class ContactMessage(models.Model):
    contact_id = models.CharField(max_length=20, primary_key=True)
    name = models.CharField(max_length=100)
    email = models.EmailField()
    message = models.TextField()
    submitted_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"From {self.name}"





