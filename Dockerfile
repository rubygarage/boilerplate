FROM ruby:2.6.5-alpine as Builder

RUN apk --no-cache add bash git openssh httpie libxml2-dev libxslt-dev postgresql-dev \
  tzdata npm nodejs imagemagick make cmake g++ postgresql-client nano

ENV APP_USER app
ENV APP_USER_HOME /home/$APP_USER
ENV APP_HOME /home/www/boilerplate_rails_api

RUN adduser -D -h $APP_USER_HOME $APP_USER

RUN mkdir /var/www && \
   chown -R $APP_USER:$APP_USER /var/www && \
   chown -R $APP_USER $APP_USER_HOME

WORKDIR $APP_HOME

USER $APP_USER

COPY Gemfile* .ruby-version ./

RUN gem i bundler -v $(tail -1 Gemfile.lock | tr -d ' ') && \
  bundle install || bundle check

COPY . .

FROM ruby:2.6.5-alpine

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

CMD bundle exec puma -C config/puma.rb
