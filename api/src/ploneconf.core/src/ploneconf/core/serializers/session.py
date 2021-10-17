from plone.restapi.interfaces import ISerializeToJsonSummary
from plone.restapi.serializer.converters import json_compatible
from ploneconf.core.content.keynote import IKeynote
from ploneconf.core.content.talk import ITalk
from ploneconf.core.content.training import ITraining
from typing import List
from zope.component import adapter
from zope.component import getUtility
from zope.interface import implementer
from zope.interface import Interface
from zope.schema.interfaces import IVocabularyFactory


ATTRIBUTE_VOCABULARY = {
    "session_audience": "ploneconf.core.vocabularies.slot_audiences",
    "session_level": "ploneconf.core.vocabularies.slot_levels",
    "track": "ploneconf.core.vocabularies.slot_tracks",
}


def get_vocabulary(attr: str, context):
    name = ATTRIBUTE_VOCABULARY.get(attr)
    factory = getUtility(IVocabularyFactory, name)
    return factory(context)


class JSONSummarySerializer:
    """ISerializeToJsonSummary adapter for the Session contents."""

    def __init__(self, context, request):
        self.context = context
        self.request = request

    def format_vocabulary_values(self, attr: str, value: set) -> List[dict]:
        """Get title and token for a value."""
        value = value or set()
        vocabulary = get_vocabulary(attr, self.context)
        response = []
        for item in value:
            term = vocabulary.getTerm(item)
            response.append(
                {
                    "title": term.title,
                    "token": term.token,
                }
            )
        return response

    def __call__(self):
        context = self.context
        level = self.format_vocabulary_values("session_level", context.session_level)
        audience = self.format_vocabulary_values(
            "session_audience", context.session_audience
        )
        track = self.format_vocabulary_values("track", context.track)
        summary = json_compatible(
            {
                "@id": self.context.absolute_url(),
                "@type": self.context.portal_type,
                "title": self.context.title,
                "description": self.context.description,
                "level": level,
                "audience": audience,
                "track": track,
                "start": context.start,
                "end": context.end,
            }
        )
        return summary


@implementer(ISerializeToJsonSummary)
@adapter(IKeynote, Interface)
class KeynoteJSONSummarySerializer(JSONSummarySerializer):
    """ISerializeToJsonSummary adapter for the Keynote."""


@implementer(ISerializeToJsonSummary)
@adapter(ITalk, Interface)
class TalkJSONSummarySerializer(JSONSummarySerializer):
    """ISerializeToJsonSummary adapter for the Talk."""


@implementer(ISerializeToJsonSummary)
@adapter(ITraining, Interface)
class TrainingJSONSummarySerializer(JSONSummarySerializer):
    """ISerializeToJsonSummary adapter for the Training."""
