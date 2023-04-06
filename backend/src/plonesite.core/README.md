# plonesite.core

Policy package to setup a simple volto site.

## Features

### CORS settings

Implement CORS settings for this package

### Content types

- Training

### Initial content

This package contains a simple volto configuration.

Installation
------------

Install plonesite.core by adding it to your buildout:
```ini
[buildout]

...

eggs =
    plonesite.core
```

Then running `buildout`

And to create the Plone site:

```shell
./bin/instance run scripts/create_site.py
```

## Contribute

- [Issue Tracker](https://github.com/plone/plonesite.org/issues)
- [Source Code](https://github.com/plone/plonesite.org/)

## License

The project is licensed under the GPLv2.
