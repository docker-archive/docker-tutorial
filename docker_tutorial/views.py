__author__ = 'thatcher'

from django.shortcuts import render_to_response, get_object_or_404
from django.template import RequestContext
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse
from .models import *

from django.contrib.sessions.models import Session


def endpoint(request):
    """
    api endpoint for saving events
    """

    return render_to_response("base/home.html", {
        "form": form,
        }, context_instance=RequestContext(request))


def testpage(request):
    """
    testing saving stuff on a users' session
    """

    username = request.session.get('username', 'unknown')
    print username

    return render_to_response("tutorial/testpage.html", {
        # "form": form,
        'username': username
    }, context_instance=RequestContext(request))


@csrf_exempt
def api(request):
    """
    testing saving stuff on a users' session
    """

    if not request.session.exists(request.session.session_key):
        request.session.create()

    session = Session.objects.get(pk=request.session.session_key)

    try:
        user = TutorialUser.objects.get(session_key=session.session_key)
    except ObjectDoesNotExist:
        user = TutorialUser.objects.create(session_key=session.session_key)

    if request.method == "POST":
        event = TutorialEvent.objects.create(user=user)
        # event.user ; is set at instantiation
        event.type = request.POST.get('type', TutorialEvent.NONE)
        # event.timestamp ; is automatically set
        event.question = request.POST.get('question', None)
        event.command = request.POST.get('command', "")
        event.feedback = request.POST.get('feedback', "")
        event.save()

    session = request.session
    print session
    username = session.get('username', 'unknown')
    print username

    return HttpResponse('.')

    # return render_to_response("tutorial/testpage.html", {
    #     "form": form,
        # 'username': username
        # }, context_instance=RequestContext(request))
