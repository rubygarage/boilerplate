# frozen_string_literal: true

namespace :api do
  namespace :doc do
    desc 'Generate API documentation Markdown'
    task :md, :version do |_task, arg|
      require 'rspec/core/rake_task'

      version = arg[:version]
      md_file = "public/api/docs/#{version}/index.md"
      RSpec::Core::RakeTask.new(:api_spec) do |t|
        t.pattern = "spec/requests/api/#{version}"
        t.rspec_opts = "-f Dox::Formatter --order defined --tag dox --out #{md_file}"
      end

      Rake::Task['api_spec'].invoke
    end

    desc 'Generate API documentation HTML'
    task :html, [:version] => [:md] do |_task, arg|
      version = arg[:version]
      md_file = "public/api/docs/#{version}/index.md"
      html_file = "public/api/docs/#{version}/index.html"

      system("aglio -i #{md_file} -o #{html_file}")
    end

    def generate_docs(version)
      Rake::Task['api:doc:html'].invoke(version)
    end

    desc 'Generate API documentation Markdown and HTML for the API v1'
    task :v1 do
      generate_docs('v1')
    end
  end
end
