require 'rails_helper'

RSpec.describe StepsConcern do
  controller(ApplicationController) do
    # rubocop:disable RSpec/DescribedClass
    include StepsConcern
    # rubocop:enable RSpec/DescribedClass

    before_action :authenticate_user!

    def test_quiz_form_params
      render json: quiz_form_params
    end

    def test_build_quiz_form_from_params
      form = build_quiz_form_from_params(params[:quiz_form])
      render json: form
    end

    def test_build_quiz_form_from_encoded_params
      form = build_quiz_form_from_encoded_params
      render json: form
    end

    def test_build_default_quiz_form
      form = build_default_quiz_form
      render json: form
    end
  end

  let(:user) { create(:user) }

  before do
    routes.draw do
      get 'test_quiz_form_params' => 'anonymous#test_quiz_form_params'
      get 'test_build_quiz_form_from_params' => 'anonymous#test_build_quiz_form_from_params'
      get 'test_build_quiz_form_from_encoded_params' => 'anonymous#test_build_quiz_form_from_encoded_params'
      get 'test_build_default_quiz_form' => 'anonymous#test_build_default_quiz_form'
    end
    allow(controller).to receive(:authenticate_user!)
    sign_in(user)
  end

  describe '#quiz_form_params' do
    let(:encoded_params) { UrlParamsEncoder.encode(quiz_form_hash) }

    it 'builds quiz form params when there are no encoded params or quiz_form params present' do
      get :test_quiz_form_params, params: { quiz_form: quiz_form_hash }
      expect(response.parsed_body).to include(quiz_form_hash)
    end

    it 'builds quiz form params when there are encoded params and quiz_form params present' do
      permitted_quiz_form_params = {
        'current_step' => '2',
        'answer_1' => 'Photosynthesis',
        'answer_2' => 'Herpetology',
        'answer_3' => 'Rosalind Franklin',
        'answer_4' => 'Java',
        'answer_5' => 'J.D. Salinger'
      }

      allow(controller).to receive(:decoded_params).and_return(ActionController::Parameters.new(permitted_quiz_form_params))

      get :test_quiz_form_params, params: { encoded_params:, quiz_form: permitted_quiz_form_params }
      expect(response.parsed_body).to include(permitted_quiz_form_params)
    end
  end

  describe '#build_quiz_form_from_params' do
    it 'builds a QuizForm from given params' do
      quiz_form_params = quiz_form_hash
      get :test_build_quiz_form_from_params, params: { quiz_form: quiz_form_params }
      form = response.parsed_body
      expect(form['answer']).to eq(['Femur', 'Isaac Newton', 'IBM', 'Mount Kilimanjaro', 'Oxygen'])
    end

    it 'builds a QuizForm with the correct user' do
      quiz_form_params = quiz_form_hash
      get :test_build_quiz_form_from_params, params: { quiz_form: quiz_form_params }
      form = response.parsed_body
      expect(form['current_user_id']).to eq(user.id)
    end
  end

  describe '#build_quiz_form_from_encoded_params' do
    let(:encoded_params) { UrlParamsEncoder.encode(quiz_form_hash) }

    it 'builds a QuizForm from encoded params' do
      get :test_build_quiz_form_from_encoded_params, params: { encoded_params: }
      form = response.parsed_body
      expect(form['answer']).to eq(['Femur', 'Isaac Newton', 'IBM', 'Mount Kilimanjaro', 'Oxygen'])
    end

    it 'builds a QuizForm with the correct user' do
      get :test_build_quiz_form_from_encoded_params, params: { encoded_params: }
      form = response.parsed_body
      expect(form['current_user_id']).to eq(user.id)
    end
  end

  describe '#build_default_quiz_form' do
    it 'builds a default QuizForm' do
      get :test_build_default_quiz_form, params: { id: 1 }
      form = response.parsed_body
      expect(form['current_step']).to eq(1)
    end

    it 'builds a default QuizForm with the correct user' do
      get :test_build_default_quiz_form, params: { id: 1 }
      form = response.parsed_body
      expect(form['current_user_id']).to eq(user.id)
    end
  end
end
