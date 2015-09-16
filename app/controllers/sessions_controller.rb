class SessionsController < ApplicationController

  before_action :assure_no_current_user, only: [:new]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_crendentials(
      params[:user][:user_name],
      params[:user][:password]
      )

    if @user.nil?
      flash.now[:errors] ||= []
      flash.now[:errors] << "Must have valid username password combo!"
      render :new
    else
      login_user!(@user)
    end
  end

  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
