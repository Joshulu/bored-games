module SessionsHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # def login

  # end

  # def logout
  #   session.delete(:user_id)
  #   current_user = nil
  # end
end
