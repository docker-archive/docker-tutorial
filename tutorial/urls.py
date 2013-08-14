from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView

from views import testpage, api

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()


urlpatterns = patterns('',
    # Examples:
    url(r'^$', testpage, name='tutorial_testpage'),
    url(r'^api/$', api, name='tutorial_api'),
    # url(r'^$', TemplateView.as_view(template_name='tutorial/snippet.html'), name='tutorial'),
    # url(r'^wwwdocker/', include('wwwdocker.foo.urls')),

    # Uncomment the admin/doc line below to enable admin documentation:
    # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

    # Uncomment the next line to enable the admin:
    # url(r'^admin/', include(admin.site.urls)),
)
