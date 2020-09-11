# frozen_string_literal: true

Rails.autoloaders.main.ignore(Rails.root.join('app/admin'))
Rails.autoloaders.main.ignore(Rails.root.join('lib/macro'))
Rails.autoloaders.main.ignore(Rails.root.join('app/channels/application_cable'))
