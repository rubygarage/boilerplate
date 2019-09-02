# frozen_string_literal: true

RSpec.describe UserMailer do
  let(:email) { FFaker::Internet.email }

  describe '#confirmation' do
    subject(:mailer) { described_class.confirmation(email, token, path) }

    let(:token) { FFaker::Internet.domain_word }
    let(:path) { FFaker::Internet.http_url }

    it 'includes confirmation data' do
      expect(mailer.to).to include(email)
      expect(mailer.from).to include(Rails.configuration.default_sender_email)
      expect(mailer.subject).to eq(I18n.t('user_mailer.confirmation.subject'))
      expect(mailer.body.encoded).to include(URI.parse("#{path}?email_token=#{token}").to_s)
    end
  end

  describe '#notification' do
    subject(:mailer) { described_class.notification(email) }

    it 'includes notification data' do
      expect(mailer.to).to include(email)
      expect(mailer.from).to include(Rails.configuration.default_sender_email)
      expect(mailer.subject).to eq(I18n.t('user_mailer.notification.subject'))
      expect(mailer.body.encoded).to include('Your account has been verified successfully')
    end
  end

  describe '#reset_password' do
    subject(:mailer) { described_class.reset_password(email, token, path) }

    let(:token) { FFaker::Internet.domain_word }
    let(:path) { FFaker::Internet.http_url }

    it 'includes reset password data' do
      expect(mailer.to).to include(email)
      expect(mailer.from).to include(Rails.configuration.default_sender_email)
      expect(mailer.subject).to eq(I18n.t('user_mailer.reset_password.subject'))
      expect(mailer.body.encoded).to include(URI.parse("#{path}?email_token=#{token}").to_s)
    end
  end
end
