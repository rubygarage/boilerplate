# frozen_string_literal: true

RSpec.describe Api::V1::Users::ResetPasswords::Worker::EmailResetPasswordUrl, type: :worker do
  describe '.perform' do
    subject(:worker) do
      described_class.new.perform(
        email: email,
        token: token,
        user_reset_password_path: user_reset_password_path
      )
    end

    let(:email) { FFaker::Internet.email }
    let(:token) { create_token(:email) }
    let(:user_reset_password_path) { FFaker::InternetSE.slug }
    let(:mailer_instance) { instance_double('MailMessage', :deliver_now) }

    it 'calls UserMailer' do
      expect(UserMailer)
        .to receive(:reset_password).with(email, token, user_reset_password_path).and_return(mailer_instance)
      expect(mailer_instance).to receive(:deliver_now)
      worker
    end
  end
end
