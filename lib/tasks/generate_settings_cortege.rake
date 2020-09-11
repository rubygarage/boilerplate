# frozen_string_literal: true

# :nocov:
namespace :settings do
  desc 'Generate a setting cortege'
  task :create, %i[key value] => [:environment] do |_task, args|
    puts 'Need pass arguments' unless args.key || args.value

    if args.key && args.value
      Setting.first_or_create(key: args.key, value: args.value)
      puts args.key.to_s
    end
  end
end
# :nocov:
