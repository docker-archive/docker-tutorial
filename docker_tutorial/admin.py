from django.contrib import admin
from django.contrib.sessions.models import Session
from .models import *


class SessionAdmin(admin.ModelAdmin):
    def _session_data(self, obj):
        return obj.get_decoded()
    list_display = ['session_key', '_session_data', 'expire_date']
admin.site.register(Session, SessionAdmin)


class TutorialEventInline(admin.TabularInline):
    model = TutorialEvent
    readonly_fields = ('timestamp', 'time_elapsed', 'question', 'type', 'command',)
    fields = ['question', 'type', 'command', 'timestamp', 'time_elapsed']
    extra = 0


class DockerfileEvenInline(admin.TabularInline):
    model = DockerfileEvent
    readonly_fields = ('timestamp', 'level', 'item', 'errors', )
    fields = ['level', 'item', 'errors', 'timestamp']
    extra = 0


class TutorialUserAdmin(admin.ModelAdmin):
    model = TutorialUser
    list_display = ['id', 'session_key', 'label', 'timestamp']
    inlines = [TutorialEventInline, DockerfileEvenInline]
admin.site.register(TutorialUser, TutorialUserAdmin)


class TutorialEventAdmin(admin.ModelAdmin):
    model = TutorialEvent
    readonly_fields = ('id', 'timestamp', 'time_elapsed')
    fields = ['id', 'user', 'type', 'question', 'command', 'timestamp', 'time_elapsed']
    list_display = ['id', 'user','type', 'question', 'timestamp']
admin.site.register(TutorialEvent, TutorialEventAdmin)


class TutorialEventFeedback(TutorialEvent):
    class Meta:
        proxy = True


class TutorialEventFeedbackAdmin(admin.ModelAdmin):
    model = TutorialEvent
    readonly_fields = ('id', 'timestamp', 'time_elapsed')
    list_display = ['id', 'user', 'question', 'feedback', 'timestamp']
    list_filter = ('type',)
admin.site.register(TutorialEventFeedback, TutorialEventFeedbackAdmin)


class SubscriberAdmin(admin.ModelAdmin):
    model = Subscriber
    list_display = ['email', 'from_level']
admin.site.register(Subscriber, SubscriberAdmin)


class DockerfileEventAdmin(admin.ModelAdmin):
    model = DockerfileEvent
    list_display = ['id', 'timestamp', 'item', 'level', 'errors']
admin.site.register(DockerfileEvent, DockerfileEventAdmin)