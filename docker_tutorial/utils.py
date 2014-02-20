from django.core.cache import cache
from django.core.exceptions import ObjectDoesNotExist

from docker_tutorial.models import TutorialUser


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
    Fetches a user if one exists, creates one otherwise.
    """
    cache_prefix = "_get_or_create_user:"
    cache_key = cache_prefix + session_key

    user = cache.get(cache_key)
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
            cache.set(cache_key, user)

    return user