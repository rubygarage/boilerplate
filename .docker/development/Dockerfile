FROM ruby:2.7.2-alpine3.12 as Builder

RUN apk --no-cache add bash git openssh httpie libxml2-dev libxslt-dev postgresql-dev \
  tzdata npm nodejs imagemagick yarn make cmake g++ postgresql-client nano

ENV APP_USER app
ENV APP_USER_HOME /home/$APP_USER
ENV APP_HOME /home/www/boilerplate-api

RUN adduser -D -h $APP_USER_HOME $APP_USER

WORKDIR $APP_HOME

USER $APP_USER

COPY Gemfile* package.json yarn.lock .ruby-version ./

RUN gem i bundler -v $(tail -1 Gemfile.lock | tr -d ' ') && \
  bundle install || bundle check \
  && rm -rf /usr/local/bundle/cache/*.gem \
  && find /usr/local/bundle/gems/ -name "*.c" -delete \
  && find /usr/local/bundle/gems/ -name "*.o" -delete

USER root

RUN yarn install --check-files

COPY . .

RUN RAILS_ENV=development rake assets:precompile

RUN rm -rf node_modules spec tmp/cache

FROM ruby:2.7.2-alpine3.12

RUN apk --no-cache add bash openssh httpie libxml2-dev libxslt-dev postgresql-dev \
  tzdata nodejs imagemagick postgresql-client nano

ENV APP_USER app
ENV APP_HOME /home/www/boilerplate-api

RUN addgroup -g 1000 -S $APP_USER && adduser -u 1000 -S $APP_USER -G $APP_USER

USER $APP_USER

COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=1000:1000 $APP_HOME $APP_HOME

WORKDIR $APP_HOME

USER $APP_USER
