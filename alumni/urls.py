from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('profile/', views.profile, name='profile'),
    path('graduate/<str:student_id>/', views.graduate_student, name='graduate_student'),

    path('register/', views.register, name='register'),
    path('login/', views.user_login, name='login'),
    path('logout/', views.user_logout, name='logout'),

    path('profile/update/', views.update_profile, name='update_profile'),
    path('profiles/', views.public_profiles_list, name='public_profiles_list'),
    path('profiles/<str:profile_id>/', views.public_profile_detail, name='public_profile_detail'),

    path('events/register/', views.register_for_event, name='register_for_event'),
    path('events/', views.events_list, name='events_list'),

    path('add-job/', views.add_job_posting, name='add_job_posting'),
    path('edit-job/<str:job_id>/', views.edit_job_posting, name='edit_job'),
    path('jobs/', views.view_jobs, name='view_jobs'),
    path('jobs/<str:job_id>/', views.job_details, name='job_details'),
    path('jobs/delete/<str:job_id>/', views.delete_job, name='delete_job'),

    path('achievements/', views.view_achievements, name='view_achievements'),
    path('achievements/add/', views.add_achievement, name='add_achievement'),
    path('achievements/edit/<str:achievement_id>/', views.edit_achievement, name='edit_achievement'),
    path('achievements/delete/<str:achievement_id>/', views.delete_achievement, name='delete_achievement'),
    path('achievements/<str:achievement_id>/', views.achievement_details, name='achievement_details'),

    path('mentorships/request/', views.add_mentorship, name='add_mentorship'),
    path('mentorship/request/<str:mentor_id>/', views.send_mentorship_request, name='send_mentorship_request'),
    path('mentorships/requests/', views.mentorship_requests_for_alumni, name='mentorship_requests_for_alumni'),
    path('mentorships/respond/<str:mentorship_id>/', views.respond_mentorship_request, name='respond_mentorship_request'),
    path('mentorships/end/<str:mentorship_id>/', views.end_mentorship, name='end_mentorship'),

    path('messages/', views.inbox, name='inbox'),
    path('messages/sent/', views.sent_messages, name='sent_messages'),
    path('messages/conversation/<str:user_id>/', views.conversation, name='conversation'),
    path('messages/send/<str:receiver_id>/', views.send_message, name='send_message'),
    path('messages/report/<str:message_id>/', views.report_message, name='report_message'),


    path('site-admin/dashboard/', views.admin_dashboard, name='admin_dashboard'),
    path('site-admin/analytics/', views.admin_analytics, name='admin_analytics'),
    path('site-admin/notifications/', views.manage_notifications, name='manage_notifications'),
    path('site-admin/events/', views.manage_events, name='manage_events'),
    path('site-admin/mentorships/', views.manage_mentorships, name='manage_mentorships'),
    path('site-admin/messages/', views.moderate_messages, name='moderate_messages'),
    path('site-admin/messages/dismiss/<str:message_id>/', views.dismiss_report, name='dismiss_report'),
    path('site-admin/messages/warn/<int:user_id>/', views.warn_user, name='warn_user'),
    path('site-admin/add-notification/', views.add_notification, name='add_notification'),
    path('site-admin/notification/delete/<str:notification_id>/', views.delete_notification, name='delete_notification'),
    path('site-admin/notification/edit/<str:notification_id>/', views.edit_notification, name='edit_notification'),
    path('site-admin/event/edit/<str:event_id>/', views.edit_event, name='edit_event'),
    path('site-admin/add-event/', views.add_event, name='add_event'),
    path('site-admin/event/delete/<str:event_id>/', views.delete_event, name='delete_event'),
    path('site-admin/message/delete/<str:message_id>/', views.delete_message, name='delete_message'),
    path('site-admin/mentorship/update/<str:mentorship_id>/', views.update_mentorship_status, name='update_mentorship_status'),
    path('site-admin/pending-admins/', views.pending_admins, name='pending_admins'),
    path('site-admin/approve/<int:user_id>/', views.approve_admin, name='approve_admin'),
    path('site-admin/users/', views.manage_users, name='manage_users'),
    path('site-admin/users/toggle/<int:user_id>/', views.toggle_user_status, name='toggle_user_status'),



    path('submit-testimonial/', views.submit_testimonial, name='submit_testimonial'),
    path('testimonials/edit/<str:testimonial_id>/', views.edit_testimonial, name='edit_testimonial'),
    path('testimonials/delete/<str:testimonial_id>/', views.delete_testimonial, name='delete_testimonial'),
    path('manage-testimonials/', views.manage_testimonials, name='manage_testimonials'),
    path('testimonials/', views.testimonials_page, name='view_testimonials'),

    path('contact/', views.contact_form, name='contact'),
    path('site-admin/contact-messages/', views.view_contact_messages, name='admin_contact_messages'),

    path('gallery/', views.gallery, name='gallery'),
    path('gallery/upload/', views.upload_gallery_image, name='upload_gallery_image'),
    path('gallery/edit/<str:gallery_id>/', views.edit_gallery_item, name='edit_gallery_item'),
    path('gallery/delete/<str:gallery_id>/', views.delete_gallery_item, name='delete_gallery_item'),

    path('notifications/', views.notifications_page, name='notifications_page'),

    path('draft/add/', views.add_student_draft, name='add_student_draft'),
    path('draft/edit/<str:draft_id>/', views.edit_student_draft, name='edit_student_draft'),
    path('draft/delete/<str:draft_id>/', views.delete_student_draft, name='delete_student_draft'),

    path('our-community/', views.our_community_view, name='our_community'),
    path('site-admin/our-community/add/', views.add_community_role, name='add_community_role'),
    path('our-community/edit/<str:role_id>/', views.edit_community_role, name='edit_community_role'),
    path('our-community/delete/<str:role_id>/', views.delete_community_role, name='delete_community_role'),

    path('search/', views.global_search, name='global_search'),

    path("student/<str:student_id>/cv/", views.generate_cv_pdf, name="generate_cv_pdf"),


    path('recommend-alumni/', views.recommend, name='recommend'),


]