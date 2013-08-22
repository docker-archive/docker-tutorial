
from django.http import HttpResponse
from .models import Subscriber



def subscribe(request):

    if request.POST:
        email = request.POST.get('email', None)
        from_level = request.POST.get('from_level', None)

        try:
            subscriber = Subscriber.objects.create(email=email, from_level=from_level)


            Subscriber.save(subscriber)

            return HttpResponse('0', status=200)

        except:
            return HttpResponse('1', status=200)

    else:
        return HttpResponse('1', status=200)
