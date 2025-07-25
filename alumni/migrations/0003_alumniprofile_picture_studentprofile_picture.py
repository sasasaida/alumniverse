# Generated by Django 5.2.3 on 2025-06-11 18:09

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('alumni', '0002_userprofile'),
    ]

    operations = [
        migrations.AddField(
            model_name='alumniprofile',
            name='picture',
            field=models.ImageField(blank=True, null=True, upload_to='profiles/alumni/'),
        ),
        migrations.AddField(
            model_name='studentprofile',
            name='picture',
            field=models.ImageField(blank=True, null=True, upload_to='profiles/students/'),
        ),
    ]
