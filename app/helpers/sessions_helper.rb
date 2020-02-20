module SessionsHelper
  # Log in as input user
  def log_in(user)
    session[:user_id] = user.id
  end
end
