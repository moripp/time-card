class ChangeAuthController < ApplicationController
  # 権限設定に関するコントローラー

  before_action :move_to_Log_in
  # before_action :check_authority_Stop_other_than_admin

  def index
    ids = User.joins(:authority).ids
    odd_records = User.where.not(id: ids)
    odd_records.each do |record|
      auth = record.build_authority(auth: 0)
      auth.save
    end
    @users = User.all.includes(:authority)
  end

  def update
    value = params.require(:value)
    user_id = params.require(:user_id)
    user = User.find(user_id)
    @result = user.authority.update(auth: value)
  end
end
