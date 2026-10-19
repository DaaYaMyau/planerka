class SubscriptionMailer < ApplicationMailer
  def welcome
    @subscription = params[:subscription]

    mail to: @subscription.email, subject: "Вы подписались на Планёрку"
  end
end
