# frozen_string_literal: true

# :nocov:
namespace :factory_bot do
  desc 'Verify that all FactoryBot factories are valid'
  task lint: :environment do
    if Rails.env.test?
      ActiveRecord::Base.connection.transaction do
        FactoryBot.lint
        raise ActiveRecord::Rollback
      end
    else
      system("bundle exec rake factory_bot:lint RAILS_ENV='test'")
      fail if $?.exitstatus.nonzero? # rubocop:disable Style/SignalException, Style/SpecialGlobalVars
    end
  end
end
# :nocov:
