#!/bin/bash
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD";
docker push piquette/web:latest
docker push piquette/web:$SITE_VERSION