from django import forms
from .db import get_db_connection

class ProfileFilterForm(forms.Form):
    department = forms.ChoiceField(choices=[('', 'Any Department')], required=False, help_text="Filter both alumni and students by department.")
    batch = forms.ChoiceField(choices=[('', 'Any Batch')], required=False, help_text="Filter alumni by batch.")
    year = forms.ChoiceField(choices=[('', 'Any Year')], required=False, help_text="Filter students by year.")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        from .db import execute_query
        # Populate department choices
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                query = "SELECT DISTINCT department FROM alumni_profile UNION SELECT DISTINCT department FROM student_profile"
                cursor.execute(query)
                departments = cursor.fetchall()
                department_choices = [('', 'Any Department')] + [(d['department'], d['department']) for d in departments if d['department']]
                self.fields['department'].choices = department_choices
                # Populate batch choices
                query = "SELECT DISTINCT batch FROM alumni_profile"
                cursor.execute(query)
                batches = cursor.fetchall()
                batch_choices = [('', 'Any Batch')] + [(b['batch'], b['batch']) for b in batches if b['batch']]
                self.fields['batch'].choices = batch_choices
                # Populate year choices
                query = "SELECT DISTINCT year FROM student_profile"
                cursor.execute(query)
                years = cursor.fetchall()
                year_choices = [('', 'Any Year')] + [(y['year'], y['year']) for y in years if y['year']]
                self.fields['year'].choices = year_choices

class AlumniProfileForm(forms.Form):
    full_name = forms.CharField(max_length=100, required=True)
    department = forms.CharField(max_length=50, required=True)
    batch = forms.CharField(max_length=10, required=True)
    job_title = forms.CharField(max_length=100, required=False)
    company = forms.CharField(max_length=100, required=False)
    linkedin = forms.URLField(max_length=100, required=False)
    bio = forms.CharField(widget=forms.Textarea, required=False)
    picture = forms.ImageField(required=False)
    remove_picture = forms.BooleanField(required=False, label="Remove profile picture")

class StudentProfileForm(forms.Form):
    full_name = forms.CharField(max_length=100, required=True)
    department = forms.CharField(max_length=50, required=True)
    year = forms.IntegerField(min_value=1, required=True)
    interests = forms.CharField(widget=forms.Textarea, required=False)
    picture = forms.ImageField(required=False)
    remove_picture = forms.BooleanField(required=False, label="Remove profile picture")


from django import forms
from .models import EventRegistration

class EventRegistrationForm(forms.ModelForm):
    class Meta:
        model = EventRegistration
        fields = ['event']
