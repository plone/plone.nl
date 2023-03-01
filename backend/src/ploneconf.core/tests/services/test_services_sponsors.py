from plone import api
from plone.restapi.testing import RelativeSession

import pytest
import transaction


SPONSORS = (
    ("diamond-1", "Sponsor 1", "diamond"),
    ("platinum-1", "Sponsor 2", "platinum"),
    ("gold-1", "Sponsor 3", "gold"),
    ("silver-1", "Sponsor 4", "silver"),
    ("bronze-1", "Sponsor 5", "bronze"),
    ("supporting-1", "Sponsor 6", "supporting"),
    ("platinum-2", "Sponsor 7", "platinum"),
    ("gold-2", "Sponsor 8", "gold"),
    ("silver-2", "Sponsor 9", "silver"),
    ("bronze-2", "Sponsor 10", "bronze"),
    ("supporting-2", "Sponsor 11", "supporting"),
    ("gold-3", "Sponsor 12", "gold"),
    ("silver-3", "Sponsor 13", "silver"),
    ("bronze-3", "Sponsor 14", "bronze"),
    ("supporting-3", "Sponsor 15", "supporting"),
    ("supporting-4", "Sponsor 16", "supporting"),
    ("supporting-5", "Sponsor 17", "supporting"),
)

ENDPOINT = "/@sponsors"


@pytest.fixture
def portal(functional):
    return functional["portal"]


@pytest.fixture
def sponsors_folder(portal):
    return portal["sponsors"]["organizations"]


@pytest.fixture(autouse=True)
def sponsors(sponsors_folder):
    with transaction.manager:
        with api.env.adopt_roles(["Manager"]):
            for sponsor_id, title, level in SPONSORS:
                content = api.content.create(
                    container=sponsors_folder,
                    type="Sponsor",
                    id=sponsor_id,
                    title=title,
                    level=level,
                )
                api.content.transition(content, "publish")


@pytest.fixture
def api_session(portal):
    base_url = portal.absolute_url()
    session = RelativeSession(base_url)
    session.headers.update({"Accept": "application/json"})
    return session


class TestSponsorsService:
    def test_get_sponsors_as_anonymous(self, api_session):
        response = api_session.get(ENDPOINT)
        assert response.status_code == 200

    def test_get_sponsors_levels(self, api_session):
        response = api_session.get(ENDPOINT)
        payload = response.json()
        assert len(payload["levels"]) == 7

    @pytest.mark.parametrize(
        "name,idx,total",
        [
            ["diamond", 0, 1],
            ["platinum", 1, 2],
            ["gold", 2, 3],
            ["silver", 3, 3],
            ["bronze", 4, 3],
            ["supporting", 5, 5],
            ["organizer", 6, 2],
        ],
    )
    def test_get_sponsors_values(self, api_session, name, idx, total):
        response = api_session.get(ENDPOINT)
        payload = response.json()
        level = payload["levels"][idx]
        assert level["id"] == name
        assert len(level["items"]) == total
