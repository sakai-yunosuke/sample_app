class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])
      # Redirect to the user info page agter logging in.
    else
      flash.now[:danger] = 'Invalid email / password combination.'
      render 'new'
    end
  end

  def destroy
  end
end
