FROM ubuntu:bionic
LABEL maintainer="marius.rieder@durchmesser.ch"

RUN apt-get update && \
    apt-get install -qy ruby2.5-dev bundler zlib1g-dev libpq-dev && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 2
