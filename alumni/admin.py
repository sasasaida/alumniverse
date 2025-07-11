from django.contrib import admin
from .models import (
    AlumniProfile, StudentProfile, Event, EventRegistration, ExemplaryAchievement,
    JobPosting, Mentorship, Message, Testimonial, AdminNotification, ContactMessage, UserProfile
)

admin.site.register(AlumniProfile)
admin.site.register(StudentProfile)
admin.site.register(Event)
admin.site.register(EventRegistration)
admin.site.register(ExemplaryAchievement)
admin.site.register(JobPosting)
admin.site.register(Mentorship)
admin.site.register(Message)
admin.site.register(Testimonial)
admin.site.register(AdminNotification)
admin.site.register(ContactMessage)
admin.site.register(UserProfile)