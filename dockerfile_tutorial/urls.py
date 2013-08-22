from django.conf.urls import patterns, include, url
from django.views.generic import TemplateView
from django.core.urlresolvers import reverse_lazy
from django.views.generic import RedirectView

# Uncomment the next two lines to enable the admin:
# from django.contrib import admin
# admin.autodiscover()


urlpatterns = patterns('',
   # Examples:

    url(r'^$', RedirectView.as_view(url=reverse_lazy('dockerfile'))),
    url(r'^dockerfile/subscribe/$', 'dockerfile_tutorial.views.subscribe', name='subscribe'),

    url(r'^dockerfile/$', TemplateView.as_view(template_name='dockerfile/introduction.html'), name='dockerfile'),
    url(r'^dockerfile/level1/$', TemplateView.as_view(template_name='dockerfile/level1.html'), name='dockerfile_level1'),



   # url(r'^api/$', api, name='tutorial_api'),
   # url(r'^stats/$', stats, name='stats'),
   # url(r'^$', TemplateView.as_view(template_name='tutorial/snippet.html'), name='tutorial'),
   # url(r'^wwwdocker/', include('wwwdocker.foo.urls')),

   # Uncomment the admin/doc line below to enable admin documentation:
   # url(r'^admin/doc/', include('django.contrib.admindocs.urls')),

   # Uncomment the next line to enable the admin:
   # url(r'^admin/', include(admin.site.urls)),
)


