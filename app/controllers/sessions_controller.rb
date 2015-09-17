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

    if @user
      login_user!(@user)
    else
      flash.now[:errors] ||= []
      flash.now[:errors] << "Must have valid username password combo!"
      render :new
    end
  end

  def destroy
    @session = Session.find_by_token(session[:session_token]) # Fix me!
    @session.destroy! if @session
    session[:session_token] = nil
    redirect_to new_session_url
  end
end
