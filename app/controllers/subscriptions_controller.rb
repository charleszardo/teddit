class SubscriptionsController < ApplicationController
  before_action :require_login, only: [:create]
  before_action :require_owner, only: [:destroy]

  def create
    subscription = Subscription.find_or_create_by(sub_id: params[:sub_id], user_id: current_user.id)

    redirect_to sub_url(params[:sub_id])
  end

  def destroy
    subscription = Subscription.find(params[:id])
    subs_sub = subscription.sub
    subscription.destroy

    redirect_to sub_url(subs_sub)
  end
end
