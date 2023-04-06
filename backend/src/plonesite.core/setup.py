"""Installer for the plonesite.core package."""
from setuptools import find_packages
from setuptools import setup


long_description = "\n\n".join(
    [
        open("README.md").read(),
        open("CONTRIBUTORS.md").read(),
        open("CHANGES.md").read(),
    ]
)


setup(
    name="plonesite.core",
    version="1.0a1",
    description="Plone Conference configuration package.",
    long_description=long_description,
    classifiers=[
        "Environment :: Web Environment",
        "Framework :: Plone",
        "Framework :: Plone :: Addon",
        "Framework :: Plone :: 6.0",
        "Programming Language :: Python",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Operating System :: OS Independent",
        "License :: OSI Approved :: GNU General Public License v2 (GPLv2)",
    ],
    keywords="Python Plone CMS",
    author="Plone Foundation",
    author_email="conf@plone.org",
    url="https://github.com/plone/plonesite.org",
    project_urls={
        "PyPI": "https://pypi.python.org/pypi/plonesite.core",
        "Source": "https://github.com/plone/plonesite.org",
        "Tracker": "https://github.com/plone/plonesite.org/issues",
    },
    license="GPL version 2",
    packages=find_packages("src", exclude=["ez_setup"]),
    namespace_packages=["plonesite"],
    package_dir={"": "src"},
    include_package_data=True,
    zip_safe=False,
    python_requires=">=3.10",
    install_requires=[
        "setuptools",
        "Plone",
        "collective.volto.formsupport[norobots]",
        "pas.plugins.authomatic",
        "kitconcept.seo",
        "collective.exportimport",
        "collective.z3cform.norobots",
        "collective.honeypot",
    ],
    extras_require={
        "test": [
            "gocept.pytestlayer",
            "mock",
            "plone.app.testing",
            "plone.restapi[test]",
            "pytest",
            "pytest-mock",
            "pytest-cov",
            "pytest-plone",
        ],
    },
    entry_points="""
    [z3c.autoinclude.plugin]
    target = plone
    [console_scripts]
    update_locale = plonesite.core.locales.update:update_locale
    """,
)
