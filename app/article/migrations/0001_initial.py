# Generated by Django 3.2.5 on 2021-07-19 12:10

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Article',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=120)),
                ('read_time', models.IntegerField(default=0)),
                ('published', models.BooleanField(default=False)),
                ('content', models.TextField()),
                ('updated_ts', models.DateTimeField()),
                ('created_ts', models.DateTimeField()),
                ('author', models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-updated_ts'],
            },
        ),
    ]
