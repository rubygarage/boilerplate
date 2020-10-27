#!/bin/bash
# Interpreter identifier

# Exit on fail
set -e

rm -f $APP_HOME/tmp/pids/server.pid
rm -f $APP_HOME/tmp/pids/sidekiq.pid

bundle exec rake db:migrate || bundle exec rake db:setup

exec "$@"
