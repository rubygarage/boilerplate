# frozen_string_literal: true

RSpec.describe Api::V1::Users::Verifications::Worker::EmailNotification, type: :worker do
  describe '.perform' do
    subject(:worker) { described_class.new.perform(email: email) }

    let(:email) { FFaker::Internet.email }
    let(:mailer_instance) { instance_double('MailMessage', :deliver_now) }

    it 'calls UserMailer' do
      expect(UserMailer)
        .to receive(:notification)
        .with(email)
        .and_return(mailer_instance)
      expect(mailer_instance).to receive(:deliver_now)
      worker
    end
  end
end
