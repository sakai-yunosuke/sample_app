module SessionsHelper
  # Log in as input user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Return current log in user
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # Return true if log in user exists
  def logged_in?
    !current_user.nil?
  end
end
