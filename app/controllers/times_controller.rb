class TimesController < ApplicationController
  def index
    @users = User.all
  end

  def new
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    binding.pry
  end
end