require 'rails_helper'

RSpec.describe SessionsController do
  describe 'GET #new' do
    it 'renders the new template' do
      get login_path
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }

    context 'with valid credentials' do
      it 'logs in the user' do
        user_params = { email: user.email, password: user.password }

        post login_path, params: { user: user_params }
        expect(response).to redirect_to(welcome_path(locale: user.language))
      end

      it 'redirects to welcome_path' do
        user_params = { email: user.email, password: user.password }

        post login_path, params: { user: user_params }
        follow_redirect!
        expect(response.body).to include(I18n.t('sessions.signed_in'))
      end
    end

    context 'with invalid credentials' do
      it 'responds with :unprocessable_content status' do
        user_params = { email: user.email, password: 'wrong_password' }

        post login_path, params: { user: user_params }
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'renders the new template' do
        user_params = { email: user.email, password: 'wrong_password' }

        post login_path, params: { user: user_params }
        expect(response).to render_template(:new)
      end

      it 'renders the new template with error message' do
        user_params = { email: user.email, password: 'wrong_password' }

        post login_path, params: { user: user_params }
        expect(response.body).to include(I18n.t('users.errors.invalid_email_or_password'))
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }

    it 'logs out the user' do
      post login_path, params: { user: attributes_for(:user) }
      delete logout_path

      expect(response).to redirect_to(login_path(locale: user.language))
    end

    it 'redirects to login_path' do
      post login_path, params: { user: attributes_for(:user) }
      delete logout_path

      follow_redirect!
      expect(response.body).to include(I18n.t('sessions.signed_out'))
    end
  end
end
