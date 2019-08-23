# frozen_string_literal: true

# :nocov:
namespace :api do
  namespace :doc do
    desc 'Generate API Blueprint documentation'
    task :apib, :version do |_task, arg|
      require 'rspec/core/rake_task'

      version = arg[:version]
      apib_file = "public/api/docs/#{version}/index.apib"
      RSpec::Core::RakeTask.new(:api_spec) do |t|
        t.pattern = "spec/requests/api/#{version}"
        t.rspec_opts = "-f Dox::Formatter --order defined --tag dox --out #{apib_file}"
      end

      Rake::Task['api_spec'].invoke
    end

    desc 'Generate API HTML documentation'
    task :html, [:version] => [:apib] do |_task, arg|
      version = arg[:version]
      apib_file = "public/api/docs/#{version}/index.apib"
      html_file = "public/api/docs/#{version}/index.html"

      system("snowboard html -o #{html_file} #{apib_file}")
    end

    def generate_docs(version)
      Rake::Task['api:doc:html'].invoke(version)
    end

    desc 'Generate API Blueprint and HTML documentation for the v1'
    task :v1 do
      generate_docs('v1')
    end
  end
end
# :nocov:
