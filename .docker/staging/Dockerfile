FROM ruby:2.7.1-alpine3.11 as Builder

ARG BUNDLE_WITHOUT
ARG RAILS_ENV

RUN apk add --update --no-cache \
    vim \
    build-base \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    tzdata \
    bash \
    curl \
    git \
    nodejs \
    imagemagick

ENV APP_USER boilerplate
ENV APP_HOME /home/www/boilerplate_rails_api

RUN addgroup -g 1000 -S $APP_USER  && adduser -u 1000 -S $APP_USER -G $APP_USER

WORKDIR $APP_HOME

USER $APP_USER

RUN gem install bundler -v 2.1.4

COPY .ruby-version $APP_HOME/
COPY Gemfile* $APP_HOME/
RUN bundle config set without 'development test'
RUN bundle install --jobs $(nproc) --retry 5 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY --chown=boilerplate:boilerplate . $APP_HOME
RUN chmod -R 777 $APP_HOME/.docker/staging/entrypoint.sh
RUN chmod +x $APP_HOME/.docker/staging/entrypoint.sh
