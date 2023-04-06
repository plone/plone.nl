"""Init and utils."""
from zope.i18nmessageid import MessageFactory

import logging


_ = MessageFactory("plonesite.core")

logger = logging.getLogger("plonesite.core")
