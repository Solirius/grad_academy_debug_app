# SessionsController handles user sessions: logging in, logging out, and session management.
class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: %i[create new]

  # GET /login
  # Displays the login form for users.
  def new
    @user = User.new
  end

  # POST /login
  # Attempts to authenticate and log in the user.
  # Redirects to the welcome page upon successful login.
  # Renders the login form with errors upon failed login.
  def create
    @user = find_user_or_new

    if user_authenticated?
      login_and_redirect
    else
      handle_invalid_credentials
    end
  end

  # DELETE /logout
  # Logs out the current user session.
  # Clears any quiz form session data.
  # Redirects to the login page with a signed out notice
  def destroy
    logout
  end

  private

  # Find a user by email or initialize a new user object.
  def find_user_or_new
    User.find_by(email: params[:user][:email].downcase) || User.new
  end

  # Authenticate the user with the provided password.
  def user_authenticated?
    @user.authenticate(params[:user][:password])
  end

  # Log in the user and redirect to the welcome page.
  def login_and_redirect
    login(@user)
    redirect_to welcome_path(locale: I18n.locale), notice: I18n.t('sessions.signed_in')
  end

  # Handle invalid credentials during login.
  def handle_invalid_credentials
    @user = User.new(user_params)
    @user.errors.add(:email, I18n.t('users.errors.invalid_email_or_password'))
    render :new, status: :unprocessable_content
  end

  # Permitted parameters for user login.
  def user_params
    params.require(:user).permit(:email)
  end
end
