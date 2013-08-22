from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView

from views import testpage, api, stats, dockerfile_event, subscribe

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()


urlpatterns = patterns('',
    # Examples:
    url(r'^$', testpage, name='tutorial_testpage'),
    url(r'^api/$', api, name='tutorial_api'),
    url(r'^api/dockerfile_event/$', dockerfile_event, name='dockerfile_event'),
    url(r'^api/subscribe/$', subscribe, name='subscribe'),
    url(r'^stats/$', stats, name='stats'),
)
