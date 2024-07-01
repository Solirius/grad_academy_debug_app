module AuthenticationHelper
  def sign_in(user)
    session[:current_user_id] = user.id
  end

  def sign_out
    session[:current_user_id] = nil
  end
end
