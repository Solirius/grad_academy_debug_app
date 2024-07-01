require 'rails_helper'

RSpec.describe StepsHelper do
  describe '#format_question' do
    it 'formats the question with the correct page number' do
      expect(helper.format_question('Question 123')).to eq('Page 123')
    end
  end

  describe '#format_quiz_question' do
    it 'returns the localized quiz question' do
      allow(I18n).to receive(:t).with('quiz_form.some_question.question_1.question').and_return('What is your name?')
      expect(helper.format_quiz_question('some_question', 0)).to eq('What is your name?')
    end
  end

  describe '#continuous_index' do
    it 'calculates the continuous index correctly' do
      stub_const('QuizConstantsHelper::QUESTIONS_PER_PAGE', 5)
      expect(helper.continuous_index(2, 3)).to eq(((2 - 1) * QuizConstantsHelper::QUESTIONS_PER_PAGE) + 3)
    end
  end

  describe '#validation_error_text' do
    it 'returns the formatted validation error text' do
      allow(I18n).to receive(:t).with('quiz_form.errors.blank_answer').and_return('can\'t be blank')
      expect(helper.validation_error_text(2, 3)).to eq('Question 8 : can\'t be blank')
    end
  end
end
