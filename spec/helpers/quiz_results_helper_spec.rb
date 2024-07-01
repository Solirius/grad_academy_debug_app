require 'rails_helper'

RSpec.describe QuizResultsHelper do
  include described_class
  include QuizConstantsHelper

  answers_hash = {
    'question_1' => ['Answer One', 'Answer One', 'Answer Four', 'Answer One', 'Answer One'],
    'question_2' => ['Answer Three', 'Answer One', 'Answer Four', 'Answer Two', 'Answer Four'],
    'question_3' => ['Answer One', 'Answer Four', 'Answer Three', 'Answer Two', 'Answer Three']
  }

  let(:quiz_results) { instance_double(Answer, answer: answers_hash) }

  describe '#scoring_metrics' do
    it 'returns an array of values' do
      result = scoring_metrics(quiz_results)
      expect(result).to be_a(Array)
    end
  end

  describe '#total_correct_answers' do
    it 'returns the total number of correct answers in the quiz results' do
      allow(I18n).to receive(:t).and_return('Answer One')

      result = total_correct_answers(quiz_results)
      expect(result).to eq(6)
    end

    it 'returns 0 if no correct answers are found in the quiz results' do
      allow(I18n).to receive(:t).and_return('Incorrect Answer')

      result = total_correct_answers(quiz_results)
      expect(result).to eq(0)
    end
  end

  describe '#score_percentage' do
    context 'when the total question is 0' do
      let(:quiz_results) { instance_double(Answer, answer: []) }

      it 'returns 0' do
        result = score_percentage(quiz_results)
        expect(result).to eq(0)
      end
    end

    context 'when a third of the answers are correct' do
      before do
        allow(self).to receive(:total_correct_answers).and_return(5)
      end

      it 'calculates the score percentage correctly' do
        result = score_percentage(quiz_results)
        expect(result).to eq(33.33)
      end
    end
  end

  describe '#check_answer' do
    context 'when given a correct answer' do
      let(:correct_answer) { 'Answer One' }
      let(:user_answer) { 'Answer One' }

      it 'returns true' do
        result = check_answer(correct_answer, user_answer)
        expect(result).to be true
      end
    end

    context 'when given correct answer in different case or with leading/trailing spaces' do
      let(:correct_answer) { 'Answer One' }
      let(:user_answer) { '   answer one   ' }

      it 'returns true' do
        result = check_answer(correct_answer, user_answer)
        expect(result).to be true
      end
    end

    context 'when given an incorrect answer' do
      let(:correct_answer) { 'Answer One' }
      let(:user_answer) { '12345678900' }

      it 'returns false' do
        result = check_answer(correct_answer, user_answer)
        expect(result).to be false
      end
    end
  end

  describe '#generate_table_row' do
    context 'when given correct, non-nil values' do
      let(:question) { I18n.t('quiz_form.question_page_1.question_1.question') }
      let(:correct_answer) { I18n.t('quiz_form.question_page_1.question_1.correct_answer') }
      let(:user_answer) { correct_answer }
      let(:answer) { ['question_1', [user_answer]] }

      it 'returns table row content with the question' do
        row_content = helper.generate_table_row(0, 0, answer)
        expect(row_content).to include("<td>#{question}</td>")
      end

      it 'returns table row content with the correct answer' do
        row_content = helper.generate_table_row(0, 0, answer)
        expect(row_content).to include("<td>#{correct_answer}</td>")
      end

      it 'returns table row content with the user answer' do
        row_content = helper.generate_table_row(0, 0, answer)
        expect(row_content).to include("<td>#{user_answer}</td>")
      end

      it 'returns table row content indicating the answer is correct' do
        row_content = helper.generate_table_row(0, 0, answer)
        expect(row_content).to include('<td>Correct</td>')
      end
    end

    context 'when given any nil values' do
      before do
        allow(answers_hash).to receive(:[]).and_return(nil)
      end

      it 'returns table row content with default values' do
        first_row = helper.generate_table_row(0, 0, answers_hash)
        expect(first_row).to include('<td>N/A</td>')
      end

      it 'returns table row content indicating the correct answer is N/A' do
        second_row = helper.generate_table_row(0, 0, answers_hash)
        expect(second_row).to include('<td>N/A</td>')
      end

      it 'returns table row content indicating the user answer is N/A' do
        third_row = helper.generate_table_row(0, 0, answers_hash)
        expect(third_row).to include('<td>N/A</td>')
      end

      it 'returns table row content indicating the answer is incorrect' do
        fourth_row = helper.generate_table_row(0, 0, answers_hash)
        expect(fourth_row).to include('<td>Incorrect</td>')
      end
    end
  end
end
