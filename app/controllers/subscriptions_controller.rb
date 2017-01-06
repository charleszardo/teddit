class SubscriptionsController < ApplicationController
  def create
    subscription = Subscription.create(sub: params[:sub_id], user: current_user)

    redirect_to sub_url(params[:sub_id])
  end

  def destroy
    subscription = Subscription.find(sub: params[:sub_id, user: current_user])
    subscription.destroy

    redirect_to sub_url(params[:sub_id])
  end
end
