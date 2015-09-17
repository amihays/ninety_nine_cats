class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  def current_user
    @session = Session.find_by_token(session[:session_token])
    return User.find(@session.user_id) if @session
  end

  def login_user!(user)
    @session = Session.create!(user_id: user.id)
    session[:session_token] = @session.token
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

end
