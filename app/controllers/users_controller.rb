# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user_by_id, only: %i[show edit update]
  before_action :redirect_to_login_unless_logged_in, only: %i[index edit update destroy]
  before_action :redirect_to_root_unless_correct_user, only: %i[edit update]
  before_action :redirect_to_root_unless_admin, only: :destroy

  def new
    @user = User.new
  end

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    redirect_to root_url and return unless @user.activated?
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url
  end

  private

  def set_user_by_id
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def redirect_to_login_unless_logged_in
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in'
      redirect_to login_url
    end
  end

  def redirect_to_root_unless_correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def redirect_to_root_unless_admin
    redirect_to(root_url) unless current_user.admin?
  end
end
