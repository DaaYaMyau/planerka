class SubscriptionsController < ApplicationController
  def create
    @subscription = Subscription.new(params.expect(subscription: [ :email, :consent ]))

    if @subscription.save
      SubscriptionMailer.with(subscription: @subscription).welcome.deliver_later
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to root_path, notice: "Вы подписаны, сообщим о запуске" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :create, status: :unprocessable_content }
        format.html { redirect_to root_path, alert: @subscription.errors.messages.values.flatten.first }
      end
    end
  end
end
