class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  private
  # サインアップの時にnameを許可する
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # サインインしてない時はログイン画面へ遷移させる
  def move_to_Log_in
    redirect_to new_user_session_path unless user_signed_in?
  end

  # 権限確認
  def check_authority_Stop_other_than_admin
    redirect_to root_path unless current_user.position.admin?
  end
end
