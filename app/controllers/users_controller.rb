class UsersController < ApplicationController

  before_action :assure_no_current_user, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      login_user!(@user)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] << "Invalid sign up stuff"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
