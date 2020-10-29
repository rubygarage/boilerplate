#!/bin/bash
# Interpreter identifier

# Exit on fail
set -e

rm -f $APP_HOME/tmp/pids/server.pid
rm -f $APP_HOME/tmp/pids/sidekiq.pid

bundle exec rake db:create
bundle exec rake db:migrate

exec "$@"
