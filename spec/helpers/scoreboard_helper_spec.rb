require 'rails_helper'

RSpec.describe ScoreboardHelper do
  describe '#generate_csvs' do
    it 'generates CSV with the correct headers' do
      users = create_list(:user, 10)
      scores = users.map { |user| create(:answer, user:) }

      csv_data = helper.generate_csvs(scores)
      expect(csv_data).to include('Quiz,Username,Date,Score')
    end

    it 'generates CSV for multiple scores' do
      users = create_list(:user, 10)
      scores = users.map { |user| create(:answer, user:) }

      csv_data = helper.generate_csvs(scores)
      scores.each do |score|
        expect(csv_data).to include("#{score.id},#{score.user.username}")
      end
    end

    it 'returns an empty CSV if no scores provided' do
      csv_data = helper.generate_csvs([])
      expect(csv_data).to eq("Quiz,Username,Date,Score\n")
    end
  end

  describe '#generate_single_csv' do
    let(:user) { create(:user, username: 'user_1') }
    let(:score) { create(:answer, user:) }
    let(:csv_data) { helper.generate_single_csv(score) }

    it 'includes the correct headers' do
      expect(csv_data).to include('Quiz_ID,Username,Date_Attempted,Overall_Score,Question,Given_Answer,Correct_Answer')
    end

    it 'includes the top-level data' do
      expect(csv_data).to include("#{score.id},#{score.user.username}")
    end

    it 'includes questions' do
      score.answer.each do |page, answers|
        answers.each_with_index do |_given_answer, index|
          page_number = page.split('_').last
          question_key = :"question_page_#{page_number}"
          question_data = I18n.t('quiz_form')[question_key][:"question_#{index + 1}"]

          next unless question_data

          question_text = question_data[:question]

          expect(csv_data).to include(question_text)
        end
      end
    end

    it 'includes user answers' do
      score.answer.each do |page, answers|
        answers.each_with_index do |given_answer, index|
          page_number = page.split('_').last
          question_key = :"question_page_#{page_number}"
          question_data = I18n.t('quiz_form')[question_key][:"question_#{index + 1}"]

          next unless question_data

          expect(csv_data).to include(given_answer)
        end
      end
    end

    it 'includes correct answers' do
      score.answer.each do |page, answers|
        answers.each_with_index do |_given_answer, index|
          page_number = page.split('_').last
          question_key = :"question_page_#{page_number}"
          question_data = I18n.t('quiz_form')[question_key][:"question_#{index + 1}"]

          next unless question_data

          correct_answer = question_data[:correct_answer]

          expect(csv_data).to include(correct_answer)
        end
      end
    end
  end
end
