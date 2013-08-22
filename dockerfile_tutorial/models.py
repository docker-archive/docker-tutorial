from django.db import models
from datetime import datetime

class Subscriber(models.Model):
    email = models.EmailField(max_length=80)
    timestamp = models.DateTimeField(auto_now=True)
    from_level = models.IntegerField()

    class Meta:
        unique_together = ("email", "from_level")

    def __unicode__(self):
        return u"{}".format(self.email)
