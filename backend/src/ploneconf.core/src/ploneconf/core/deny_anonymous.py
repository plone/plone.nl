from plone import api
from plone.subrequest.interfaces import ISubRequest
from urllib.parse import urlparse
from zope.component import adapter
from ZPublisher.interfaces import IPubAfterTraversal

import logging
import os


logger = logging.getLogger(__name__)

FORCE_AUTH_ENV = "FORCE_AUTH"
FORCE_AUTH = os.getenv(FORCE_AUTH_ENV, False)
if FORCE_AUTH:
    try:
        FORCE_AUTH = int(FORCE_AUTH)
    except (ValueError, TypeError, AttributeError):
        logger.warning("Ignored non-integer %s environment variable.", FORCE_AUTH_ENV)
        FORCE_AUTH = False

# List of suffixes at the end of a url that we accept without forcing authentication.
# This is to avoid getting a redirect for all resources.
ALLOWED_SUFFIXES = set("css ico jpeg jpg js png svg gif".split())
# Accept login page, and a few other common pages.
ALLOWED_PAGES = set(
    "failsafe_login logged-out login login_form login-help logout ok plonejsi18n require_login".split()
)
# We must accept urls like this:
# http://localhost:8080/nl/passwordreset/131c7cee777a4b6c9573e00cf35912db
ALLOWED_URL_PARTS = set("passwordreset".split())


@adapter(IPubAfterTraversal)
def force_authentication(event):
    """Force authentication.

    Anonymous users are redirected to the login form,
    except for a few pages and resources.

    By default this is not active.
    Set an environment variable: FORCE_AUTH=1.
  
    Maybe show something with css/js when body has class userrole-authenticated and not plone-toolbar-left.
    """
    request = event.request
    if ISubRequest.providedBy(request):
        # Let's accept any subrequest, probably from Mosaic or Diazo.
        return
    url = request.ACTUAL_URL
    path = urlparse(url).path
    if path.rsplit(".")[-1] in ALLOWED_SUFFIXES:
        return
    page = path.rsplit("/")[-1]
    # @@login -> login
    page = page.lstrip("@")
    if page in ALLOWED_PAGES:
        return
    if ALLOWED_URL_PARTS.intersection(set(path.split("/"))):
        # One of the allowed url parts is in our path.
        return
    # First get the portal.  If this does not work, then other api calls
    # would fail with the same error.
    try:
        portal = api.portal.get()
    except api.exc.CannotGetPortalError:
        # We are at Zope root.
        return
    if not api.user.is_anonymous():
        # print("Not anonymous.")
        return
    logger.info("Force auth setting env: %s", FORCE_AUTH)
    if not (FORCE_AUTH):
        logger.info("Not forcing auth.")
        return
    # Note: failsafe_login is a stripped down version of the login form,
    # in CMFPlone itself, which only renders the form, and no navigation,
    # footer, etcetera.
    url = f"{portal.absolute_url()}/failsafe_login?came_from={url}"
    logger.info("Denying anonymous access, redirecting to %s" % url)
    request.response.redirect(url, lock=True, status=307)
