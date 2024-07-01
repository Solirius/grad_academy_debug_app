require 'rails_helper'

RSpec.describe Answer do
  let(:user) { create(:user) }
  let(:answer) { create(:answer, user:) }

  describe 'associations' do
    it 'belongs to a user' do
      expect(answer.user).to eq(user)
    end

    it 'is deleted when user is deleted' do
      user.answers << answer
      expect { user.destroy }.to(change(described_class, :count).by(-1))
    end
  end

  describe 'validations' do
    it 'has a valid answer' do
      answer = build(:answer, answer: nil)
      expect(answer).not_to be_valid
    end

    it 'has a valid date_attempted' do
      answer = build(:answer, date_attempted: nil)
      expect(answer).not_to be_valid
    end

    it 'has a valid completed' do
      answer = build(:answer, completed: nil)
      expect(answer).not_to be_valid
    end
  end

  describe 'errors' do
    context 'when there are 5 answers' do
      it 'is valid' do
        answer = build(:answer, answer: { question_1: %w[a b c d e] })
        expect(answer).to be_valid
      end

      it 'does not add errors' do
        answer = build(:answer, answer: { question_1: %w[a b c d e] })
        expect(answer.errors.full_messages).to eq([])
      end
    end

    context 'when there are less than 5 answers' do
      it 'is not valid' do
        answer = build(:answer, answer: { question_1: %w[a b c d] })
        expect(answer).not_to be_valid
      end

      it 'adds errors' do
        answer = build(:answer, answer: { question_1: %w[a b c d] })
        answer.save
        expect(answer.errors.full_messages).to include("Answer #{I18n.t('answers.errors.unanswered_questions')}")
      end
    end
  end
end
