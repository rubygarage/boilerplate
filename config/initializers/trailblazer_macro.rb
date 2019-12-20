# frozen_string_literal: true

Dir[Rails.root.join('lib/macro/**/*.rb')].sort.each { |file| require file }
