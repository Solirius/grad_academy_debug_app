# rubocop:disable RSpec/FilePath, RSpec/SpecFilePathFormat
require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    include Authentication

    before_action :redirect_if_authenticated
    before_action :authenticate_user!, only: [:index]

    def index
      render plain: 'Index Page'
    end
  end

  let(:user) { create(:user) }

  describe 'before_action :current_user' do
    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      it 'sets current_user' do
        get :index
        expect(assigns(:current_user)).to eq(user)
      end

      it 'returns true for user_signed_in?' do
        get :index
        expect(controller.send(:user_signed_in?)).to be_truthy
      end
    end

    context 'when user is not logged in' do
      it 'does not set current_user' do
        get :index
        expect(assigns(:current_user)).to be_nil
      end

      it 'returns false for user_signed_in?' do
        get :index
        expect(controller.send(:user_signed_in?)).to be_falsey
      end
    end
  end

  describe '#login and #logout' do
    it 'logs in the user' do
      controller.send(:login, user)
      expect(session[:current_user_id]).to eq(user.id)
    end

    it 'logs out the user' do
      controller.send(:login, user)
      allow(controller).to receive(:redirect_to)
      controller.send(:logout)
      expect(session[:current_user_id]).to be_nil
    end
  end

  describe '#redirect_if_authenticated' do
    context 'when user is logged in' do
      before { session[:current_user_id] = user.id }

      it 'redirects to welcome_path' do
        get :index
        expect(response).to redirect_to(welcome_path(locale: user.language))
      end

      it 'sets flash alert message' do
        get :index
        expect(flash[:alert]).to eq(I18n.t('authentication.redirect_if_authenticated_message'))
      end
    end

    context 'when user is not logged in' do
      it 'does not redirect' do
        get :index
        expect(response).not_to redirect_to(welcome_path)
      end
    end
  end

  describe '#authenticate_user!' do
    context 'when user is not logged in' do
      before do
        get :index
      end

      it 'redirects to login_path' do
        expect(response).to redirect_to(login_path(locale: I18n.locale))
      end

      it 'has a 3XX status' do
        expect(response).to have_http_status(:found)
      end

      it 'displays the correct notice' do
        expect(flash[:alert]).to eq(I18n.t('authentication.redirect_if_not_authenticated_message'))
      end
    end
  end
end
# rubocop:enable RSpec/FilePath, RSpec/SpecFilePathFormat
