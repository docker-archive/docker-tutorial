# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'TutorialUser'
        db.create_table(u'tutorial_tutorialuser', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('session_key', self.gf('django.db.models.fields.CharField')(max_length=80)),
        ))
        db.send_create_signal(u'tutorial', ['TutorialUser'])

        # Adding model 'TutorialEvent'
        db.create_table(u'tutorial_tutorialevent', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['tutorial.TutorialUser'])),
            ('type', self.gf('django.db.models.fields.CharField')(max_length=15)),
            ('timestamp', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('question', self.gf('django.db.models.fields.IntegerField')(null=True, blank=True)),
            ('command', self.gf('django.db.models.fields.CharField')(default='', max_length=80, blank=True)),
            ('feedback', self.gf('django.db.models.fields.CharField')(default='', max_length=2000, blank=True)),
        ))
        db.send_create_signal(u'tutorial', ['TutorialEvent'])


    def backwards(self, orm):
        # Deleting model 'TutorialUser'
        db.delete_table(u'tutorial_tutorialuser')

        # Deleting model 'TutorialEvent'
        db.delete_table(u'tutorial_tutorialevent')


    models = {
        u'tutorial.tutorialevent': {
            'Meta': {'object_name': 'TutorialEvent'},
            'command': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '80', 'blank': 'True'}),
            'feedback': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '2000', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '15'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['tutorial.TutorialUser']"})
        },
        u'tutorial.tutorialuser': {
            'Meta': {'object_name': 'TutorialUser'},
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'session_key': ('django.db.models.fields.CharField', [], {'max_length': '80'})
        }
    }

    complete_apps = ['tutorial']