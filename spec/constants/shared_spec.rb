# frozen_string_literal: true

RSpec.describe Constants::Shared do
  describe 'defined constants' do
    it { expect(described_class).to be_const_defined(:EMAIL_REGEX) }
    it { expect(described_class).to be_const_defined(:PASSWORD_REGEX) }
    it { expect(described_class).to be_const_defined(:PASSWORD_MIN_SIZE) }
    it { expect(described_class).to be_const_defined(:EMAIL_MAX_LENGTH) }
    it { expect(described_class).to be_const_defined(:HMAC_SECRET) }

    def match_regex_pattern?(email)
      regex_pattern.match?(email)
    end

    describe 'Constants::Shared::EMAIL_REGEX' do
      subject(:regex_pattern) { described_class::EMAIL_REGEX }

      it 'email user name should be > 0, may be any char' do
        expect(match_regex_pattern?('email@domain.com')).to be(true)
        expect(match_regex_pattern?('!@domain.com')).to be(true)
        expect(match_regex_pattern?('@domain.com')).to be(false)
      end

      it 'email should contain @' do
        expect(match_regex_pattern?('email@domain.com')).to be(true)
        expect(match_regex_pattern?('email')).to be(false)
      end

      it 'TLD should contain only letters in range 2..63' do
        expect(match_regex_pattern?('email@a.aa')).to be(true)
        expect(match_regex_pattern?('email@a.a')).to be(false)
        expect(match_regex_pattern?("email@a.#{'a' * 64}")).to be(false)
      end

      it 'email should be not TLD email' do
        expect(match_regex_pattern?('email@aa')).to be(false)
      end

      it 'email should be subdomain email' do
        expect(match_regex_pattern?('email@1.aa')).to be(true)
        expect(match_regex_pattern?('email@1-1.aa')).to be(true)
        expect(match_regex_pattern?('email@1_1.aa')).to be(false)
      end
    end

    describe 'Constants::Shared::PASSWORD_REGEX' do
      subject(:regex_pattern) { described_class::PASSWORD_REGEX }

      it 'contains letters, numbers, non-whitespace characters' do
        expect(match_regex_pattern?('Password1!')).to be(true)
        expect(match_regex_pattern?('Password1@')).to be(true)
        expect(match_regex_pattern?('Password1#')).to be(true)
        expect(match_regex_pattern?('Password1$')).to be(true)
        expect(match_regex_pattern?('Password1%')).to be(true)
        expect(match_regex_pattern?('Password1^')).to be(true)
        expect(match_regex_pattern?('Password1&')).to be(true)
        expect(match_regex_pattern?('Password1*')).to be(true)
        expect(match_regex_pattern?('Password1-')).to be(true)
        expect(match_regex_pattern?('Password1_')).to be(true)
      end
    end

    describe 'Constants::Shared::PASSWORD_MIN_SIZE' do
      it { expect(described_class::PASSWORD_MIN_SIZE).to eq(8) }
    end

    describe 'Constants::Shared::EMAIL_MAX_LENGTH' do
      it { expect(described_class::EMAIL_MAX_LENGTH).to eq(255) }
    end

    describe 'Constants::Shared::HMAC_SECRET' do
      it { expect(described_class::HMAC_SECRET).to eq('test') }
    end
  end
end
