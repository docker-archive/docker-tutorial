__author__ = 'thatcher'

from django.shortcuts import render_to_response, get_object_or_404
from django.template import RequestContext
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from django.core.exceptions import ObjectDoesNotExist
from django.http import HttpResponse
from .models import *
import json

from django.contrib.sessions.models import Session


def endpoint(request):
    """
    api endpoint for saving events
    """

    return render_to_response("base/home.html", {
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

    session = Session.objects.filter(pk=request.session.session_key).latest('pk')

    try:
        user = TutorialUser.objects.filter(session_key=session.session_key).latest('pk')
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

def stats(request):


    users = {}
    users['started'] = TutorialUser.objects.all().count()
    users['completed'] = TutorialEvent.objects.filter(type='complete').count()


    i = 0
    answered = {}
    while i < 9:
        number = TutorialEvent.objects.filter(type='next', question=i).count()
        answered[i] = number
        i = i + 1


    # find which question people look for the answer
    i = 0
    peeks = {}
    while i < 9:
        number = TutorialEvent.objects.filter(type='peek', question=i).count()
        peeks[i] = number
        i = i + 1


    outputformat = request.GET.get("format", None)
    if outputformat:
        response = {}
        response['users'] = users
        response['peeks'] = peeks
        response['answered'] = answered
        jsonresponse = json.dumps(response)
        return HttpResponse(jsonresponse, mimetype="application/json")

    return render_to_response("tutorial/stats.html", {
        'users': users,
        'peeks': peeks,
        'answered': answered
    }, context_instance=RequestContext(request))

