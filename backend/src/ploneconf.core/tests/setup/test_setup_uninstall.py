"""Setup tests for this package."""
import pytest


PACKAGE_NAME = "ploneconf.core"


class TestSetupUninstall:
    @pytest.fixture(autouse=True)
    def uninstall(self, installer):
        installer.uninstall_product(PACKAGE_NAME)

    def test_product_uninstalled(self, installer):
        """Test if ploneconf.core is uninstalled."""
        assert installer.is_product_installed(PACKAGE_NAME) is False

    def test_browserlayer_removed(self, browser_layers):
        """Test that IPloneConfCoreLayer is removed."""
        from ploneconf.core import interfaces as ifaces

        assert ifaces.IPloneConfCoreLayer not in browser_layers
