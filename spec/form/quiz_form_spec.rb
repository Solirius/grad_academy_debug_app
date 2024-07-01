require 'rails_helper'

RSpec.describe 'QuizForm' do
  let(:user) { create(:user) }
  let(:quiz_form) { build(:quiz_form, current_user_id: user.id) }
  let(:quiz_form_with_nil_answers) { build(:quiz_form, :with_nil_answers) }

  describe 'validations' do
    it('has a valid answers') do
      expect(quiz_form).to be_valid
    end

    context 'when answers are nil or empty' do
      %w[answer_1 answer_2 answer_3 answer_4 answer_5].each do |answer|
        context "with #{answer}" do
          it 'validates presence' do
            expect(quiz_form_with_nil_answers).not_to be_valid
          end

          it 'returns the correct error message' do
            quiz_form_with_nil_answers.valid?
            expect(quiz_form_with_nil_answers.errors.full_messages).to include(/#{I18n.t('quiz_form.errors.blank_answer')}/)
          end
        end
      end
    end
  end

  describe 'attributes' do
    it('has a current_step') do
      expect(quiz_form.current_step).to eq(1)
    end

    it 'has a current_user_id' do
      expect(quiz_form.current_user_id).to eq(user.id)
    end
  end

  describe 'initialize' do
    it('creates a new quiz form') do
      expect(quiz_form).to be_a(QuizForm)
    end

    it('creates a new quiz form when given new attributes') do
      expect(QuizForm.new(answer: { question_1: ['a'], question_2: ['free text'], question_3: ['c'] })).to be_a(QuizForm)
    end
  end

  describe 'update_answers' do
    it('creates a new answer when the user has not completed any answers today') do
      expect { quiz_form.update_answers }.to change(Answer, :count).by(1)
    end

    it('updates the users last answer when given a new answer hash to append') do
      quiz_form.update_answers
      expect { quiz_form.update_answers }.not_to(change { user.answers.last.answer.size })
    end
  end

  describe 'steps' do
    it('has a total_steps') do
      expect(quiz_form.total_steps).to eq(3)
    end

    it('has a current_step') do
      expect(quiz_form.current_step).to eq(1)
    end

    it('sets the step when given a current step') do
      quiz_form.current_step = 2
      expect(quiz_form.current_step).to eq(2)
    end
  end

  describe 'previous_answers' do
    it('returns the previous answers') do
      quiz_form.update_answers

      expect(quiz_form.previous_answers).to eq(user.answers.last)
    end
  end
end
