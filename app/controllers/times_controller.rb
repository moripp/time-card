class TimesController < ApplicationController
  def index
    return nil if params[:keyword] == ""
    @users = User.where(['name LIKE ?', "%#{params[:keyword]}%"]).limit(10)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
  end
end