# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation(email, token, path)
    @email = email
    @confirmation_url = URI.parse("#{path}?email_token=#{token}").to_s
    mail(to: email, subject: I18n.t('user_mailer.confirmation.subject'))
  end

  def notification(email)
    @email = email
    mail(to: email, subject: I18n.t('user_mailer.notification.subject'))
  end
end
