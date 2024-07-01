require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it 'has a valid username' do
      user = build(:user, username: nil)
      expect(user).not_to be_valid
    end

    context 'when email is not present' do
      it 'has an invalid email' do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end
    end

    context 'when an email is present' do
      it 'has a valid email' do
        user = build(:user)
        expect(user).to be_valid
      end

      it 'is invalid if the email format is invalid' do
        user = build(:user, email: 'invalid_email')
        expect(user).not_to be_valid
      end

      it 'is invalid if the email is not unique' do
        user = create(:user)
        user_with_same_email = build(:user, email: user.email)
        expect(user_with_same_email).not_to be_valid
      end
    end

    it 'has a valid password' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
    end
  end
end
