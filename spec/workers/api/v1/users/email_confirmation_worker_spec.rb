# frozen_string_literal: true

RSpec.describe Api::V1::Users::EmailConfirmationWorker, type: :worker do
  describe 'class settings' do
    it { expect(described_class.new).to be_a(Sidekiq::Worker) }
  end

  describe '.perform' do
    subject(:worker) do
      described_class.new.perform(
        email: email,
        token: token,
        user_verification_path: user_verification_path
      )
    end

    let(:email) { FFaker::Internet.email }
    let(:token) { create_token(:email) }
    let(:user_verification_path) { FFaker::InternetSE.slug }
    let(:mailer_instance) { instance_double('MailMessage', :deliver_now) }

    it 'calls UserMailer' do
      expect(UserMailer)
        .to receive(:confirmation).with(email, token, user_verification_path).and_return(mailer_instance)
      expect(mailer_instance).to receive(:deliver_now)
      worker
    end
  end
end
