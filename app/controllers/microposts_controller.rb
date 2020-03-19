# frozen_string_literal: true

class MicropostsController < ApplicationController
  before_action :redirect_to_login_unless_logged_in, only: %i[create destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      render 'static_page/home'
    end
  end

  def destroy
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content)
  end
end
