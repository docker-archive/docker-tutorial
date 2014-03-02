from django.db import models
from datetime import datetime

__author__ = 'thatcher'


class TutorialUser(models.Model):
    session_key = models.CharField(max_length=40, unique=True)  # natural key
    timestamp = models.DateTimeField(auto_now=True, default=datetime.now)
    label = models.CharField(max_length=80, default='', blank=True)
    http_user_agent = models.TextField(default='', blank=True)
    http_remote_address = models.TextField(default='', blank=True)
    http_real_remote_address = models.TextField(default='', blank=True)
    http_accept_language = models.TextField(default='', blank=True)
    http_referrer = models.TextField(default='', blank=True)

    def __unicode__(self):
        return u"%s" % (self.id)


class TutorialEvent(models.Model):

    NONE = 'none'
    START = 'start'
    COMMAND = 'command'
    NEXT = 'next'
    FEEDBACK = 'feedback'
    PEEK = 'peek'
    COMPLETE = 'complete'


    EVENT_TYPES = (
        (NONE, u'No type set (debug)'),
        (START, u'Start tutorial'),
        (COMMAND, u'Command given'),
        (NEXT, u'Next Question'),
        (FEEDBACK, u'Feedback'),
        (PEEK, u'Peek'),
        (COMPLETE, u'Tutorial Complete')
    )

    user = models.ForeignKey(TutorialUser)
    type = models.CharField(max_length=15, choices=EVENT_TYPES, blank=False)
    timestamp = models.DateTimeField(auto_now=True)
    question = models.IntegerField(null=True, blank=True)
    command = models.CharField(max_length=80, blank=True, default="")
    feedback = models.CharField(max_length=2000, blank=True, default="")

    @property
    def time_elapsed(self):
        time_elapsed = self.timestamp - TutorialEvent.objects.filter(user=self.user).order_by('pk')[0].timestamp
        return time_elapsed.seconds

    def __unicode__(self):
        return str(self.id)


class DockerfileEvent(models.Model):

    user = models.ForeignKey(TutorialUser)
    item = models.CharField(max_length=15, blank=False)
    timestamp = models.DateTimeField(auto_now=True)
    level = models.IntegerField(null=True, blank=True)
    errors = models.IntegerField(null=True, blank=True)

    @property
    def time_elapsed(self):
        time_elapsed = self.timestamp - TutorialEvent.objects.filter(user=self.user).order_by('pk')[0].timestamp
        return time_elapsed.seconds

    def __unicode__(self):
        return str(self.id)


class Subscriber(models.Model):

    email = models.EmailField(max_length=80)
    user = models.ForeignKey(TutorialUser)
    timestamp = models.DateTimeField(auto_now=True)
    from_level = models.IntegerField()

    class Meta:
        unique_together = ("email", "from_level")

    def __unicode__(self):
        return u"{}".format(self.email)
