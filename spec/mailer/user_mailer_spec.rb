# frozen_string_literal: true

RSpec.describe UserMailer do
  describe '#confirmation' do
    subject(:mailer) { described_class.confirmation(email, token, path) }

    let(:email) { FFaker::Internet.email }
    let(:token) { FFaker::Internet.domain_word }
    let(:path) { FFaker::Internet.http_url }

    it 'includes confirmation data' do
      expect(mailer.to).to include(email)
      expect(mailer.from).to include(Rails.configuration.default_sender_email)
      expect(mailer.subject).to eq(I18n.t('user_mailer.subject'))
      expect(mailer.body.encoded).to include(URI.parse("#{path}?email_token=#{token}").to_s)
    end
  end
end
