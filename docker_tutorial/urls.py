from django.conf.urls import patterns, url

from . import views


urlpatterns = patterns('',
    url(r'^$', views.testpage, name='tutorial_testpage'),
    url(r'^api/$', views.api, name='tutorial_api'),
    url(r'^api/dockerfile_event/$', views.dockerfile_event, name='dockerfile_event'),
    url(r'^api/subscribe/$', views.subscribe, name='subscribe'),
    url(r'^api/metrics/$', views.get_metrics, name='get_metrics'),
    url(r'^stats/$', views.stats, name='stats'),
)
