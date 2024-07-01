require 'rails_helper'

RSpec.describe ApplicationController do
  # Define a dummy controller to include ApplicationController behavior
  controller do
    include Authentication

    # Define an action to test the before_action callbacks
    before_action :clear_quiz_session_data, unless: :on_quiz_page?
    before_action :set_locale

    def index
      render plain: 'Index Page'
    end
  end

  describe '#set_locale' do
    let(:user) { create(:user, language: 'fr') } # Replace with your User model and factory

    context 'when user is authenticated' do
      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'sets locale to user language' do
        get :index
        expect(I18n.locale).to eq(:fr)
      end
    end

    context 'when user is not authenticated' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-US,en;q=0.9'
      end

      it 'sets locale based on browser settings' do
        get :index
        expect(I18n.locale).to eq(:en)
      end
    end
  end

  describe '#extract_locale_from_accept_language_header' do
    it 'extracts locale from Accept-Language header' do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7'
      expect(controller.send(:extract_locale_from_accept_language_header)).to eq('fr')
    end
  end

  describe '#clear_quiz_session_data' do
    it 'clears quiz session data' do
      session[:quiz_forms] = { question: 'answer' }
      controller.send(:clear_quiz_session_data)
      expect(session[:quiz_forms]).to be_nil
    end
  end

  describe '#on_quiz_page?' do
    it 'returns true for quiz page actions' do
      allow(controller).to receive_messages(controller_name: 'steps', action_name: 'show')
      expect(controller.send(:on_quiz_page?)).to be_truthy
    end

    it 'returns false for non-quiz page actions' do
      allow(controller).to receive_messages(controller_name: 'home', action_name: 'index')
      expect(controller.send(:on_quiz_page?)).to be_falsey
    end
  end
end
