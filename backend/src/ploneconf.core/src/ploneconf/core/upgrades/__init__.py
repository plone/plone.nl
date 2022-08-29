from plone import api
from ploneconf.core import logger


def upgrade_plone(context):
    """Upgrade Plone to latest version."""
    mt = api.portal.get_tool("portal_migration")
    if mt.needUpgrading():
        mt.upgrade()
        logger.info("Upgraded Plone")


def upgrade_pas_plugins_authomatic(portal_setup):
    """Upgrade pas.plugins.authomatic to latest version."""
    portal_setup.upgradeProfile("profile-pas.plugins.authomatic:default")
    logger.info("Upgraded pas.plugins.authomatic")


def upgrade_catalog(context):
    portal_setup = api.portal.get_tool("portal_setup")
    portal_setup.runImportStepFromProfile("ploneconf.core:default", "catalog")
