from django.contrib import admin
from .models import *


class SubscriberAdmin(admin.ModelAdmin):
    model = Subscriber
    list_display = ['email', 'from_level']

admin.site.register(Subscriber, SubscriberAdmin)