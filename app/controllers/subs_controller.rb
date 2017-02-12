class SubsController < ApplicationController
  # before_action :require_login, only: [:new, :create]
  # before_action :require_owner, only: [:edit, :update, :destroy]

  def index
    @subs = Sub.order(:title).page params[:page]
    
    render :index
  end
end
