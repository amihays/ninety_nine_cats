class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    User.find_by_session_token(session[:session_token])
  end

  def login_user!(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
    redirect_to cats_url
  end

  def assure_no_current_user
    redirect_to cats_url if current_user
  end

  def assure_logged_in
    redirect_to new_session_url if current_user.nil?
  end


  def assure_correct_owner
    @cat = Cat.find(params[:id])
    if @cat.user_id != current_user.id
      redirect_to cats_url
      flash[:errors] ||= []
      flash[:errors] << "You don't own this cat!"
    end
  end

  helper_method :current_user
end
