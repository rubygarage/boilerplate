FROM ruby:2.7.1-alpine3.11 as Builder

RUN apk add --update --no-cache \
  bash httpie libxml2-dev libxslt-dev git postgresql-dev \
  tzdata nodejs imagemagick yarn make cmake g++ postgresql-client nano

ENV APP_USER app
ENV APP_USER_HOME /home/$APP_USER
ENV APP_HOME /home/www/boilerplate_rails_api

RUN adduser -D -h $APP_USER_HOME $APP_USER

WORKDIR $APP_HOME

USER $APP_USER

COPY Gemfile* package.json yarn.lock .ruby-version ./

RUN gem install bundler -v 2.1.4 && \
  bundle install || bundle check

USER root

RUN yarn install

COPY . .

FROM ruby:2.7.1-alpine3.11

RUN apk --no-cache add bash openssh httpie libxml2-dev libxslt-dev postgresql-dev \
  tzdata nodejs imagemagick postgresql-client nano

ENV APP_USER app
ENV APP_HOME /home/www/boilerplate_rails_api

RUN addgroup -g 1000 -S $APP_USER && adduser -u 1000 -S $APP_USER -G $APP_USER

USER $APP_USER

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=1000:1000 $APP_HOME $APP_HOME

WORKDIR $APP_HOME

USER $APP_USER
