__author__ = 'thatcher'

from django.shortcuts import render_to_response, get_object_or_404
from django.template import RequestContext
from django.views.decorators.csrf import csrf_exempt, csrf_protect
from django.core.exceptions import ObjectDoesNotExist
from django.contrib.sessions.models import Session
from django.http import HttpResponse
from .models import TutorialUser, TutorialEvent, DockerfileEvent, Subscriber
import json



def get_user_for_request(request):
    """
    Function checks for an existing session, and creates one if necessary
    then checks for existing tutorialUser, and creates one if necessary
    returns this tutorialUser
    """

    if not request.session.exists(request.session.session_key):
        request.session.create()

    session = Session.objects.filter(pk=request.session.session_key).latest('pk')

    try:
        user = TutorialUser.objects.filter(session_key=session.session_key).latest('pk')
    except ObjectDoesNotExist:
        user = TutorialUser.objects.create(
            session_key=session.session_key,
            http_user_agent=request.META.get('HTTP_USER_AGENT', None),
            http_remote_address=request.META.get('REMOTE_ADDR', None),
            http_accept_encoding=request.META.get('HTTP_ACCEPT_ENCODING', None),
            http_accept_language=request.META.get('HTTP_ACCEPT_LANGUAGE', None),
            http_referrer=request.META.get('HTTP_REFERER', None)
        )
    return user


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
    saving the users' events
    """

    user = get_user_for_request(request)

    if request.method == "POST":
        event = TutorialEvent.objects.create(user=user)
        # event.user ; is set at instantiation
        event.type = request.POST.get('type', TutorialEvent.NONE)
        # event.timestamp ; is automatically set
        event.question = request.POST.get('question', None)
        event.command = request.POST.get('command', "")
        event.feedback = request.POST.get('feedback', "")
        event.save()

    return HttpResponse('.')

def dockerfile_event(request):
    """
    saving the dockerfile events
    """

    user = get_user_for_request(request)

    if request.method == "POST":
        event = DockerfileEvent.objects.create(user=user)
        # event.user ; is set at instantiation
        ## default type is 'none'
        event.errors = request.POST.get('errors', None)
        event.level = request.POST.get('level', None)
        event.item = request.POST.get('item', 'none')
        # event.timestamp ; is automatically set
        event.save()

    return HttpResponse('0')


def subscribe(request):
    """
    Save the users' email. -- Mainly / only meant for notifying them of the availability of
    a next tutorial
    """

    user = get_user_for_request(request)

    if request.POST:
        email = request.POST.get('email', None)
        from_level = request.POST.get('from_level', None)

        try:
            subscriber = Subscriber.objects.create(user=user, email=email, from_level=from_level)
            Subscriber.save(subscriber)
            return HttpResponse('0', status=200)
        except:
            return HttpResponse('1', status=200)
    else:
        return HttpResponse('1', status=200)


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
