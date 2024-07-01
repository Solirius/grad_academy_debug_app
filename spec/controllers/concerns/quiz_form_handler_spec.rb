require 'rails_helper'

RSpec.describe QuizFormHandler do
  controller(ApplicationController) do
    include QuizFormHandler
  end

  let(:user) { create(:user) }
  let(:quiz_form) { QuizForm.new(current_step: 1, current_user_id: user.id) }

  before do
    allow(controller).to receive_messages(current_user: user, params: { id: '1' })
    session[:quiz_forms] = [quiz_form.attributes]
  end

  describe '#next_step' do
    before do
      controller.instance_variable_set(:@quiz_form, quiz_form)
      allow(controller).to receive(:redirect_to)
    end

    it 'redirects to the next step with the correct params' do
      expected_encoded_params = UrlParamsEncoder.encode(answer: quiz_form.answer, current_step: 2)
      controller.next_step
      expect(controller).to have_received(:redirect_to).with(step_path(id: 2, encoded_params: expected_encoded_params, locale: user.language))
    end

    it 'advances to the next step if current step is less than total steps' do
      controller.next_step
      expect(controller.instance_variable_get(:@quiz_form).current_step).to eq(2)
    end
  end

  describe '#reset_user_completion_status' do
    it 'resets the user completion status' do
      answer = create(:answer, user:, completed: true)
      allow(user).to receive(:answers).and_return([answer])
      allow(user.answers).to receive(:last).and_return(answer)

      controller.reset_user_completion_status
      expect(answer.reload.completed).to be_falsey
    end
  end

  describe '#build_quiz_form_with_answers' do
    it 'builds the quiz form with answers' do
      allow(controller).to receive(:params).and_return(id: '1')
      controller.build_quiz_form_with_answers
      quiz_form = controller.instance_variable_get(:@quiz_form)
      expect(quiz_form.current_step).to eq(1)
    end

    it 'builds the quiz form with user' do
      allow(controller).to receive(:params).and_return(id: '1')
      controller.build_quiz_form_with_answers
      quiz_form = controller.instance_variable_get(:@quiz_form)
      expect(quiz_form.current_user_id).to eq(user.id)
    end
  end

  describe '#set_answer_for_question' do
    it 'sets the answer for a specific question' do
      controller.instance_variable_set(:@quiz_form, quiz_form)
      controller.set_answer_for_question(0, 'Answer 1')
      expect(controller.instance_variable_get(:@quiz_form).answer_1).to eq('Answer 1')
    end
  end

  describe '#clear_quiz_form_session_data' do
    it 'clears the quiz form session data' do
      controller.clear_quiz_form_session_data
      expect(session[:quiz_forms]).to be_nil
    end
  end
end
