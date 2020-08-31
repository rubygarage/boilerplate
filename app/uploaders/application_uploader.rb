# frozen_string_literal: true

require 'image_processing/mini_magick'

class ApplicationUploader < Shrine
  Shrine.plugin :activerecord
  Shrine.plugin :cached_attachment_data
  Shrine.plugin :restore_cached_data
end
