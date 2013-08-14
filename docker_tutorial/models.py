__author__ = 'thatcher'

from django.db import models
from django.contrib.sessions.models import Session
from datetime import datetime


class TutorialUser(models.Model):
    session_key = models.CharField(max_length=80)
    timestamp = models.DateTimeField(auto_now=True, default=datetime.now)
    label = models.CharField(max_length=80, default='', blank=True, null=True)

    def __unicode__(self):
        return u"%s" % (self.id)

class TutorialEvent(models.Model):

    NONE = 'none'
    START = 'start'
    COMMAND = 'command'
    NEXT = 'next'
    FEEDBACK = 'feedback'
    COMPLETE = 'complete'


    EVENT_TYPES = (
        (NONE, u'No type set (debug)'),
        (START, u'Start tutorial'),
        (COMMAND, u'Command given'),
        (NEXT, u'Next Question'),
        (FEEDBACK, u'Feedback'),
        (COMPLETE, u'Tutorial Complete'),
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