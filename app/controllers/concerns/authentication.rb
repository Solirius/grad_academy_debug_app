# Authentication module provides methods for user authentication and session management.
module Authentication
  extend ActiveSupport::Concern

  included do
    # Sets up before_action to initialize current_user and helper methods for views.
    before_action :current_user
    helper_method :current_user
    helper_method :user_signed_in?
  end

  # Logs in the specified user by resetting the session and storing user id.
  def login(user)
    reset_session
    session[:current_user_id] = user.id
  end

  # Logs out the current user by resetting the session.
  def logout
    reset_session
    self.response ||= ActionDispatch::Response.new
    redirect_to login_path(locale: I18n.locale), notice: t('sessions.signed_out')
  end

  # Redirects to welcome page with alert if user is already authenticated.
  def redirect_if_authenticated
    return unless user_signed_in?

    redirect_to welcome_path(locale: I18n.locale), alert: t('authentication.redirect_if_authenticated_message')
  end

  # Redirects to login page with alert if user is not authenticated.
  def authenticate_user!
    return if user_signed_in?

    redirect_to login_path(locale: I18n.locale),
                alert: t('authentication.redirect_if_not_authenticated_message')
  end

  # Retrieves the currently logged-in user based on session.
  def current_user
    @current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
  end

  # Checks if a user is currently signed in.
  def user_signed_in?
    current_user.present?
  end
end
