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

    url(r'^dockerfile/$', TemplateView.as_view(template_name='dockerfile/introduction.html'), name='dockerfile'),
    url(r'^dockerfile/level1/$', TemplateView.as_view(template_name='dockerfile/level1.html'), name='dockerfile_level1'),

)


