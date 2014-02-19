# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):

        # Changing field 'TutorialUser.http_user_agent'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_user_agent', self.gf('django.db.models.fields.TextField')())

        # Changing field 'TutorialUser.http_real_remote_address'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_real_remote_address', self.gf('django.db.models.fields.TextField')())

        # Changing field 'TutorialUser.http_remote_address'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_remote_address', self.gf('django.db.models.fields.TextField')())

        # Changing field 'TutorialUser.http_accept_language'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_accept_language', self.gf('django.db.models.fields.TextField')())

        # Changing field 'TutorialUser.http_referrer'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_referrer', self.gf('django.db.models.fields.TextField')())

        # Changing field 'TutorialUser.session_key'
        db.alter_column(u'docker_tutorial_tutorialuser', 'session_key', self.gf('django.db.models.fields.CharField')(unique=True, max_length=40))
        # Adding unique constraint on 'TutorialUser', fields ['session_key']
        db.create_unique(u'docker_tutorial_tutorialuser', ['session_key'])


    def backwards(self, orm):
        # Removing unique constraint on 'TutorialUser', fields ['session_key']
        db.delete_unique(u'docker_tutorial_tutorialuser', ['session_key'])


        # Changing field 'TutorialUser.http_user_agent'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_user_agent', self.gf('django.db.models.fields.CharField')(max_length=256))

        # Changing field 'TutorialUser.http_real_remote_address'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_real_remote_address', self.gf('django.db.models.fields.CharField')(max_length=32))

        # Changing field 'TutorialUser.http_remote_address'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_remote_address', self.gf('django.db.models.fields.CharField')(max_length=32))

        # Changing field 'TutorialUser.http_accept_language'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_accept_language', self.gf('django.db.models.fields.CharField')(max_length=128))

        # Changing field 'TutorialUser.http_referrer'
        db.alter_column(u'docker_tutorial_tutorialuser', 'http_referrer', self.gf('django.db.models.fields.CharField')(max_length=128))

        # Changing field 'TutorialUser.session_key'
        db.alter_column(u'docker_tutorial_tutorialuser', 'session_key', self.gf('django.db.models.fields.CharField')(max_length=80))

    models = {
        u'docker_tutorial.dockerfileevent': {
            'Meta': {'object_name': 'DockerfileEvent'},
            'errors': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'item': ('django.db.models.fields.CharField', [], {'max_length': '15'}),
            'level': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['docker_tutorial.TutorialUser']"})
        },
        u'docker_tutorial.subscriber': {
            'Meta': {'unique_together': "(('email', 'from_level'),)", 'object_name': 'Subscriber'},
            'email': ('django.db.models.fields.EmailField', [], {'max_length': '80'}),
            'from_level': ('django.db.models.fields.IntegerField', [], {}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['docker_tutorial.TutorialUser']"})
        },
        u'docker_tutorial.tutorialevent': {
            'Meta': {'object_name': 'TutorialEvent'},
            'command': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '80', 'blank': 'True'}),
            'feedback': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '2000', 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'question': ('django.db.models.fields.IntegerField', [], {'null': 'True', 'blank': 'True'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'auto_now': 'True', 'blank': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '15'}),
            'user': ('django.db.models.fields.related.ForeignKey', [], {'to': u"orm['docker_tutorial.TutorialUser']"})
        },
        u'docker_tutorial.tutorialuser': {
            'Meta': {'object_name': 'TutorialUser'},
            'http_accept_language': ('django.db.models.fields.TextField', [], {'default': "''", 'blank': 'True'}),
            'http_real_remote_address': ('django.db.models.fields.TextField', [], {'default': "''", 'blank': 'True'}),
            'http_referrer': ('django.db.models.fields.TextField', [], {'default': "''", 'blank': 'True'}),
            'http_remote_address': ('django.db.models.fields.TextField', [], {'default': "''", 'blank': 'True'}),
            'http_user_agent': ('django.db.models.fields.TextField', [], {'default': "''", 'blank': 'True'}),
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'label': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '80', 'blank': 'True'}),
            'session_key': ('django.db.models.fields.CharField', [], {'unique': 'True', 'max_length': '40'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now', 'auto_now': 'True', 'blank': 'True'})
        }
    }

    complete_apps = ['docker_tutorial']