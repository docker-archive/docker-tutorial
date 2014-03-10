import logging 

from django.core.cache import cache
from django.core.exceptions import ObjectDoesNotExist
from docker_tutorial.models import TutorialUser
from django.contrib.auth import authenticate, login

log = logging.getLogger(__name__)

def get_user_for_request(request):
    """
    Function checks for an existing session, and creates one if necessary
    then checks for existing tutorialUser, and creates one if necessary
    returns this tutorialUser
    """
    session_key = request.session._get_or_create_session_key()
    return _get_or_create_user(request, session_key)


def _get_or_create_user(request, session_key):
    """
    Creates a user if one exists, creates one otherwise.
    """
    user = cache.get(session_key)
    if user is None:
        try:
            user = TutorialUser.objects.filter(
                session_key=session_key).latest('pk')
        except ObjectDoesNotExist:
            user = TutorialUser.objects.create(
                session_key=session_key,

                # store some metadata about the user
                http_user_agent=request.META.get('HTTP_USER_AGENT', ''),
                http_remote_address=request.META.get('REMOTE_ADDR', ''),
                http_real_remote_address=request.META.get(
                    'HTTP_X_FORWARDED_FOR', ''),
                http_accept_language=request.META.get(
                    'HTTP_ACCEPT_LANGUAGE', ''),
                http_referrer=request.META.get('HTTP_REFERER', '')
            )
        finally:
            cache.set(session_key, user)

    return user


def login_user(username, password, request):
    """
    Function to login the user with username and password
    """

    # just log that the user is already authenticated.
    if request.user.is_authenticated():
        log.debug("login function: User already authenticated")

    # check if username and password are correct
    user = authenticate(username=username, password=password)
    if user is not None:
        if user.is_active:
            login(request, user)
            log.debug("login function: user {} is active and now logged in".format(username))
            return 0, "user successfully logged in"
        else:
            log.debug("login function: user {} is not active".format(username))
            return 1, "user not active"
    else:
        log.debug("login function: user is not set, login failed")
        return 1, "login failed"
