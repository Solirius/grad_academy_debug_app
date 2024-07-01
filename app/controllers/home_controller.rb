# HomeController handles requests related to the home page of the application.
class HomeController < ApplicationController
  before_action :redirect_if_not_logged_in

  # GET /home/index --> actually redirects to /welcome
  # Displays the home page.
  def index; end

  private

  # Redirect to login page if user is not logged in
  def redirect_if_not_logged_in
    redirect_to login_path(locale: I18n.locale) unless user_signed_in?
  end
end
