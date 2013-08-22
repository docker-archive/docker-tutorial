# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'Subscriber'
        db.create_table(u'docker_tutorial_subscriber', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('email', self.gf('django.db.models.fields.EmailField')(max_length=80)),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['docker_tutorial.TutorialUser'])),
            ('timestamp', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('from_level', self.gf('django.db.models.fields.IntegerField')()),
        ))
        db.send_create_signal(u'docker_tutorial', ['Subscriber'])

        # Adding unique constraint on 'Subscriber', fields ['email', 'from_level']
        db.create_unique(u'docker_tutorial_subscriber', ['email', 'from_level'])

        # Adding model 'DockerfileEvent'
        db.create_table(u'docker_tutorial_dockerfileevent', (
            (u'id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('user', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['docker_tutorial.TutorialUser'])),
            ('item', self.gf('django.db.models.fields.CharField')(max_length=15)),
            ('timestamp', self.gf('django.db.models.fields.DateTimeField')(auto_now=True, blank=True)),
            ('level', self.gf('django.db.models.fields.IntegerField')(null=True, blank=True)),
            ('errors', self.gf('django.db.models.fields.IntegerField')(null=True, blank=True)),
        ))
        db.send_create_signal(u'docker_tutorial', ['DockerfileEvent'])


    def backwards(self, orm):
        # Removing unique constraint on 'Subscriber', fields ['email', 'from_level']
        db.delete_unique(u'docker_tutorial_subscriber', ['email', 'from_level'])

        # Deleting model 'Subscriber'
        db.delete_table(u'docker_tutorial_subscriber')

        # Deleting model 'DockerfileEvent'
        db.delete_table(u'docker_tutorial_dockerfileevent')


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
            u'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'label': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '80', 'null': 'True', 'blank': 'True'}),
            'session_key': ('django.db.models.fields.CharField', [], {'max_length': '80'}),
            'timestamp': ('django.db.models.fields.DateTimeField', [], {'default': 'datetime.datetime.now', 'auto_now': 'True', 'blank': 'True'})
        }
    }

    complete_apps = ['docker_tutorial']