# frozen_string_literal: true

if defined?(Bullet)
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = true

      Bullet.bullet_logger = true
      Bullet.console = true
      Bullet.raise = Rails.env.test?
    end
  end
end
