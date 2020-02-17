#!/bin/bash
REPO=registry.logicspark.com/nginx
VERSION=1.17.6-letsencrypt
CONTAINER_NAME=load-balance

docker network create net-nginx

docker rm -f $CONTAINER_NAME
docker build -t ${REPO}:${VERSION} .
docker run -d \
    --name $CONTAINER_NAME \
    --network net-nginx \
    -v `pwd`/domain-management:/opt/domain-management \
    -v `pwd`/certs:/etc/letsencrypt \
    -v `pwd`/nginx-conf:/etc/nginx/conf.d/ \
    -e DOMAIN=my.domain.example.com \
    -e EMAIL=my.email@my.provider.example.com \
    -p 80:80 \
    -p 443:443 \
    ${REPO}:${VERSION}

# docker push ${REPO}:${VERSION}