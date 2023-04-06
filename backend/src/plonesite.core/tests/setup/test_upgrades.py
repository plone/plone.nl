"""Upgrades tests for this package."""
from Products.GenericSetup.upgrade import listUpgradeSteps

import pytest


PROFILE = "plonesite.core:default"


def _match(item, source, dest):
    source, dest = tuple([source]), tuple([dest])
    return item["source"] == source and item["dest"] == dest


@pytest.fixture
def available_steps(setup_tool):
    def func(src: str, dst: str) -> list:
        steps = listUpgradeSteps(setup_tool, PROFILE, src)
        steps = [s for s in steps if _match(s[0], src, dst)]
        return steps

    return func


class TestUpgrades:
    @pytest.mark.parametrize(
        "src,dst,expected",
        [
            ("20230302001", "20231002001", 0),
        ],
    )
    def test_available(self, available_steps, src, dst, expected):
        """Test upgrade step is available."""
        steps = available_steps(src, dst)
        assert len(steps) == expected
