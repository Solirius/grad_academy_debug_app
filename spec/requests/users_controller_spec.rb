require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'PATCH #edit' do
    context 'when a user is signed in' do
      before do
        sign_in(user)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it 'has a memoized @edit variable to hold the top score' do
        create(:answer, user:, completed: true, score: 100)
        get :edit, params: { id: user.id }
        expect(assigns(:edit)).to eq(100)
      end

      it 'handles errors in the @edit instance variable' do
        get :edit, params: { id: user.id }
        expect(assigns(:edit)).to eq('No score available')
      end

      it 'renders the user/edit page' do
        get :edit, params: { id: user.id }
        expect(response).to render_template(:edit)
      end

      it 'updates the username when given a new username' do
        patch :update, params: { id: user.id, user: { username: 'newusername' } }
        user.reload
        expect(user.username).to eq('newusername')
      end

      it 'redirects to the edit profile page' do
        patch :update, params: { id: user.id, user: { username: 'newusername' } }
        user.reload
        expect(response).to redirect_to(edit_user_path(locale: user.language))
      end
    end

    context 'when a user is not signed in' do
      it 'redirects to login' do
        get :edit
        expect(response).to redirect_to(login_path(locale: user.language))
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :create, params: { user: { username: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password' } }
        }.to change(User, :count).by(1)
      end

      it 'redirects to root path' do
        post :create, params: { user: { username: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password' } }

        expect(response).to redirect_to(welcome_path(locale: user.language))
      end

      it 'displays a notice' do
        post :create, params: { user: { username: 'testuser', email: 'test@example.com', password: 'password', password_confirmation: 'password' } }

        expect(flash[:notice]).to eq(I18n.t('users.signed_up'))
      end
    end

    context 'with invalid parameters' do
      it 'responds with :unprocessable_content status' do
        post :create, params: { user: { username: '', email: 'invalid-email', password: 'short', password_confirmation: 'wrong_confirmation' } }

        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'renders the new template' do
        post :create, params: { user: { username: '', email: 'invalid-email', password: 'short', password_confirmation: 'wrong_confirmation' } }

        expect(response).to render_template(:new)
      end
    end
  end
end
