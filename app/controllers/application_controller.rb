class ApplicationController < ActionController::Base
  before_action :basic_auth, if: :production?
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :request_path

  #ログイン後の画面遷移
  def after_sign_in_path_for(resource)
    user_path(resource.id)
  end

  private

  def production?
    Rails.env.production?
  end

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["BASIC_AUTH_USER"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  protected
  def request_path
    @path = controller_path + '#' + action_name
    def @path.is(*str)
      str.map{|s| self.include?(s)}.include?(true)
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :family_name, :last_name, :family_name_kana, :last_name_kana, :birthday_info, :phone_number])
  end
end
