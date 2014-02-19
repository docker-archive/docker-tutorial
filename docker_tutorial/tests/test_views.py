from django.core.urlresolvers import reverse
from django.test import TestCase


class WhenGettingTheTutorialAPI(TestCase):

    def setUp(self):
        self.response  = self.client.get(reverse("tutorial_api"))

    def test_that_the_response_is_successful(self):
        self.assertEqual(self.response.status_code, 200)


class WhenPostingToTheAPI(TestCase):

    def setUp(self):
        self.response = self.client.post(reverse("tutorial_api"))

    def test_that_the_response_is_successful(self):
        self.assertEqual(self.response.status_code, 200)
