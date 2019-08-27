# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation(email, token, path)
    @email = email
    @confirmation_url = URI.parse("#{path}?email_token=#{token}").to_s
    mail(to: email, subject: I18n.t('user_mailer.subject'))
  end
end
