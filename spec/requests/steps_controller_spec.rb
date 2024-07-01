# rubocop:disable RSpec/AnyInstance
require 'rails_helper'
require 'uri'

RSpec.describe StepsController do
  let(:user) { create(:user) }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get '/steps/1', params: { id: 1 }
      expect(response).to render_template('show')
    end

    context 'when encoded params are present' do
      let(:encoded_params_value) { encoded_params(quiz_form_hash) }

      it 'assigns a new quiz_form' do
        get '/steps/1', params: { id: 1, encoded_params: encoded_params_value }
        expect(assigns(:quiz_form)).to be_a(QuizForm)
      end

      it 'assigns current_user_id' do
        get '/steps/1', params: { id: 1, encoded_params: encoded_params_value }
        expect(assigns(:quiz_form).current_user_id).to eq(user.id)
      end
    end

    context 'with quiz_form params' do
      it 'assigns @quiz_form with correct params' do
        get '/steps/1', params: { id: 1, quiz_form: { current_step: 1, answer: { question_1: ['a'], question_2: ['free text'], question_3: ['c'] } } }
        expect(assigns(:quiz_form)).to be_a(QuizForm)
      end
    end

    context 'without quiz_form params' do
      it 'assigns @quiz_form with correct params' do
        get '/steps/1', params: { id: 1 }
        expect(assigns(:quiz_form)).to be_a(QuizForm)
      end
    end
  end

  describe 'GET #edit' do
    let(:encoded_params_value) { encoded_params(quiz_form_hash) }

    it 'resets user completion status' do
      expect_any_instance_of(described_class).to receive(:reset_user_completion_status)
      get '/steps/1/edit', params: { id: 1, encoded_params: encoded_params_value, current_user_id: user.id }
    end

    # it 'builds quiz form with answers' do
    #   expect_any_instance_of(described_class).to receive(:build_quiz_form_with_answers)
    #   get '/steps/1/edit', params: { id: 1, encoded_params: encoded_params_value, current_user_id: user.id }
    # end

    it 'restores quiz form state from session' do
      expect_any_instance_of(described_class).to receive(:restore_quiz_form_state)
      get '/steps/1/edit', params: { id: 1, encoded_params: encoded_params_value, current_user_id: user.id }
    end
  end

  describe 'POST #update' do
    let(:quiz_form_params) { generate_quiz_form_params(['a'] * 5) }
    let(:randomised_quiz_form_params) { generate_randomized_quiz_form_params }
    let(:quiz_form_encoded_params) { encoded_params(quiz_form_params) }
    let(:randomised_quiz_form_encoded_params) { encoded_params(randomised_quiz_form_params) }
    let(:randomised_params_answer) {
      [
        randomised_quiz_form_params[:answer_1],
        randomised_quiz_form_params[:answer_2],
        randomised_quiz_form_params[:answer_3],
        randomised_quiz_form_params[:answer_4],
        randomised_quiz_form_params[:answer_5]
      ]
    }

    context 'with valid quiz_form' do
      before do
        allow_any_instance_of(QuizForm).to receive(:valid?).and_return(true)
        allow_any_instance_of(QuizForm).to receive(:update_answers)
      end

      it 'assigns @quiz_form' do
        patch '/steps/1', params: { current_step: 1, id: 1, quiz_form: quiz_form_params }
        expect(assigns(:quiz_form)).to be_a(QuizForm)
      end

      context 'with static params' do
        it 'calls update_answers' do
          patch '/steps/1', params: { current_step: 1, id: 1, encoded_params: quiz_form_encoded_params }
          UrlParamsEncoder.encode(current_step: 2, answer: %w[a a a a a])
          expect(assigns(:quiz_form)).to have_received(:update_answers)
        end

        it 'redirects to next step' do
          patch '/steps/1', params: { current_step: 1, id: 1, encoded_params: quiz_form_encoded_params }
          generated_params = generate_encoded_params_and_url(1, %w[a a a a a])
          expect(response).to redirect_to("#{step_path(id: 2, locale: user.language)}?encoded_params=#{generated_params[:encoded_params_safe]}")
        end
      end

      context 'with encoded params' do
        it 'calls update_answers' do
          patch '/steps/1', params: { current_step: 1, id: 1, encoded_params: randomised_quiz_form_encoded_params }
          expect(assigns(:quiz_form)).to have_received(:update_answers)
        end

        it 'redirects to next step' do
          patch '/steps/1', params: { current_step: 1, id: 1, encoded_params: randomised_quiz_form_encoded_params }
          generated_params = generate_encoded_params_and_url(1, randomised_params_answer)
          expect(response).to redirect_to("#{step_path(id: 2, locale: user.language)}?encoded_params=#{generated_params[:encoded_params_safe]}")
        end
      end
    end

    context 'with invalid quiz_form' do
      before do
        allow_any_instance_of(QuizForm).to receive(:valid?).and_return(false)
      end

      it 'assigns @quiz_form' do
        patch '/steps/1', params: { id: 1, quiz_form: quiz_form_params }
        expect(assigns(:quiz_form)).to be_a(QuizForm)
      end

      it 'renders the show template' do
        patch '/steps/1', params: { id: 1, quiz_form: quiz_form_params }
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #check_your_answers' do
    context 'when marking the last answer as completed and rendering the template' do
      it 'assigns @quiz_results' do
        answer = create(:answer, user:, completed: false)
        get '/steps/check_your_answers', params: { quiz_results: answer, current_step: 3 }
        expect(assigns(:quiz_results)).to eq(answer)
      end

      it 'marks the last answer as completed' do
        answer = create(:answer, user:, completed: false)
        get '/steps/check_your_answers', params: { quiz_results: answer, current_step: 3 }
        expect(answer.reload.completed).to be_truthy
      end

      it 'renders the check_your_answers template' do
        answer = create(:answer, user:, completed: false)
        get '/steps/check_your_answers', params: { quiz_results: answer, current_step: 3 }
        expect(response).to render_template('check_your_answers')
      end
    end

    context 'when deleting all unfinished quiz attempts' do
      it 'assigns @quiz_results with the most recent answer' do
        recent_answer = create(:answer, user:, completed: false, created_at: 1.hour.ago)
        get '/steps/check_your_answers', params: { quiz_results: recent_answer, current_step: 3 }
        expect(assigns(:quiz_results)).to eq(recent_answer.reload)
      end

      it 'marks the most recent answer as completed' do
        recent_answer = create(:answer, user:, completed: false, created_at: 1.hour.ago)
        get '/steps/check_your_answers', params: { quiz_results: recent_answer, current_step: 3 }
        expect(recent_answer.reload.completed).to be_truthy
      end

      it 'deletes older incomplete answers' do
        older_answer = create(:answer, user:, completed: false, created_at: 1.day.ago)
        recent_answer = create(:answer, user:, completed: false, created_at: 1.hour.ago)
        get '/steps/check_your_answers', params: { quiz_results: recent_answer, current_step: 3 }
        expect { older_answer.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it 'ensures no unfinished quiz attempts exist' do
        _older_answer = create(:answer, user:, completed: false, created_at: 1.day.ago)
        recent_answer = create(:answer, user:, completed: false, created_at: 1.hour.ago)
        get '/steps/check_your_answers', params: { quiz_results: recent_answer, current_step: 3 }
        expect(user.answers.where(completed: false)).to be_empty
      end
    end
  end

  describe 'GET #scoreboard' do
    context 'when at least 10 completed answers' do
      it 'has the correct top_answers instance variable' do
        top_answers = create_list(:answer, 10, user:, completed: true)
        get '/steps/scoreboard'
        expect(assigns(:top_scores)).to match_array(top_answers)
      end

      it 'renders the scoreboard template' do
        get '/steps/scoreboard'
        expect(response).to render_template('scoreboard')
      end

      it 'includes user objects in top_scores' do
        create_list(:answer, 10, user:, completed: true)
        get '/steps/scoreboard'
        assigns(:top_scores).each do |answer|
          expect(answer.user).to be_a(User)
        end
      end
    end

    context 'when no complete answers' do
      it 'top_scores instance variable is empty' do
        create_list(:answer, 10, user:, completed: false)
        get '/steps/scoreboard'
        expect(assigns(:top_scores)).to be_empty
      end

      it 'renders the scoreboard template' do
        create_list(:answer, 10, user:, completed: false)
        get '/steps/scoreboard'
        expect(response).to render_template('scoreboard')
      end
    end
  end
end
# rubocop:enable RSpec/AnyInstance
