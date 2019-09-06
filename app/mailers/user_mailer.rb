# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def confirmation(email, token, path)
    @email = email
    @confirmation_url = URI.parse("#{path}?email_token=#{token}").to_s
    mail(to: email, subject: I18n.t('user_mailer.confirmation.subject'))
  end

  def verification_successful(email)
    @email = email
    mail(to: email, subject: I18n.t('user_mailer.verification_successful.subject'))
  end

  def reset_password(email, token, path)
    @email = email
    @reset_password_url = URI.parse("#{path}?email_token=#{token}").to_s
    mail(to: email, subject: I18n.t('user_mailer.reset_password.subject'))
  end

  def reset_password_successful(email)
    @email = email
    mail(to: email, subject: I18n.t('user_mailer.reset_password_successful.subject'))
  end
end
