__author__ = 'thatcher'
from django import forms


class UserNameForm(forms.Form):
    name = forms.CharField()

