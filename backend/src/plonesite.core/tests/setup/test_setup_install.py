"""Setup tests for this package."""


PACKAGE_NAME = "plonesite.core"
PROFILE = "plonesite.core:default"


class TestSetupInstall:
    def test_product_installed(self, installer):
        """Test if plonesite.core is installed."""
        assert installer.is_product_installed(PACKAGE_NAME) is True

    def test_browserlayer(self, browser_layers):
        """Test that IPlonesiteCoreLayer is registered."""
        from plonesite.core import interfaces as ifaces

        assert ifaces.IPlonesiteCoreLayer in browser_layers

    def test_latest_version(self, setup_tool):
        """Test latest version of default profile."""
        assert setup_tool.getLastVersionForProfile(PROFILE)[0] == "20230302001"
