"""Setup tests for this package."""
import pytest


PACKAGE_NAME = "plonesite.core"


class TestSetupUninstall:
    @pytest.fixture(autouse=True)
    def uninstall(self, installer):
        installer.uninstall_product(PACKAGE_NAME)

    def test_product_uninstalled(self, installer):
        """Test if plonesite.core is uninstalled."""
        assert installer.is_product_installed(PACKAGE_NAME) is False

    def test_browserlayer_removed(self, browser_layers):
        """Test that IPlonesiteCoreLayer is removed."""
        from plonesite.core import interfaces as ifaces

        assert ifaces.IPlonesiteCoreLayer not in browser_layers
