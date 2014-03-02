import json

from django.shortcuts import render_to_response
from django.template import RequestContext
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse

from . import utils
from .models import TutorialUser, TutorialEvent, DockerfileEvent, Subscriber

__author__ = 'thatcher'


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
    saving the user's events
    """
    if request.method == "POST":
        user = utils.get_user_for_request(request)

        event = TutorialEvent.objects.create(
            user=user,
            type=request.POST.get('type', TutorialEvent.NONE),
            question=request.POST.get('question', None),
            command=request.POST.get('command', "")[:79],
            feedback=request.POST.get('feedback', ""),
        )

    return HttpResponse('.')


def dockerfile_event(request):
    """
    saving the dockerfile events
    """

    if request.method == "POST":
        user = utils.get_user_for_request(request)
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
    if request.POST:
        user = utils.get_user_for_request(request)
        email = request.POST.get('email', None)
        from_level = request.POST.get('from_level', None)

        try:
            subscriber = Subscriber.objects.create(
                user=user, email=email, from_level=from_level)
            Subscriber.save(subscriber)
            return HttpResponse('0', status=200)
        except:
            return HttpResponse('1', status=200)
    else:
        return HttpResponse('1', status=200)


def stats(request):


    users = {}
    users['started'] = TutorialUser.objects.all().count()
    users['completed'] = TutorialEvent.objects.values_list('user', 'type').filter(type='complete').distinct().count()

    i = 0
    answered = {}
    while i < 9:
        number = TutorialEvent.objects.values_list('user', 'type', 'question').filter(type='next', question=i).distinct().count()
        answered[i] = number
        i = i + 1

    # Append the completed, because question 9 has no 'next'
    answered[9] = users['completed']


    # find which question people look for the answer
    i = 0
    peeks = {}
    while i < 10:
        number = TutorialEvent.objects.values_list('user', 'type', 'question').filter(type='peek', question=i).distinct().count()
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


def get_metrics(request):

    users = {}

    # TutorialUsers = TutorialUser.objects.all()
    # users['started_interactive'] = TutorialUsers.filter(TutorialEvent__count > 0)
    # users['completed'] = TutorialEvent.objects.filter(type='complete').count()

    interactive_start_count = TutorialEvent.objects.values_list('user').distinct().count()
    interactive_complete_count = TutorialEvent.objects.values_list('user','type').filter(type=TutorialEvent.COMPLETE).distinct().count()

    dockerfile_tutorial_count = DockerfileEvent.objects.values_list('user').distinct().count()
    dockerfile_tutorial_complete_level1 = DockerfileEvent.objects.values_list('user', 'level', 'errors').filter(errors=0).distinct().count()

    response = []
    response.append({'name': 'tutorial_interactive_started', 'value_i': interactive_start_count})
    response.append({'name': 'tutorial_interactive_completed', 'value_i': interactive_complete_count})
    response.append({'name': 'dockerfile_tutorial_total', 'value_i': dockerfile_tutorial_count})
    response.append({'name': 'tutorial_dockerfile_completed_level1', 'value_i': dockerfile_tutorial_complete_level1})

    jsonresponse = json.dumps(response)

    return HttpResponse(jsonresponse, mimetype="application/json")
