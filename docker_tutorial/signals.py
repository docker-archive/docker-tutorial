from django.dispatch import Signal

tutorial_login = Signal(providing_args=["username", "password"])

