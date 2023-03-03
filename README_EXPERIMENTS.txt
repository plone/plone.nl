Here are some notes on improvements I have added to the Makefile that
are up for discussion or better implementations/alternatives.

** make build-images  

split to make-build-frontend and make-build-backend so you can build them in parallel
with make -j2 build-images .  There were always sequential

The NOCACHE=1 flag will force the builds to be fresh:
NOCACHE=1 make -j2 build-images

** override.yml

I don't want my data in a docker volume, I want a bind mount! Override files to the rescue.
Also for any other customisation for local docker compose development
Rename overide.yml.orig to override.yml and it is loaded after /devops/dev/local-dev.yml
