class SubscriptionMailerPreview < ActionMailer::Preview
  def welcome
    SubscriptionMailer.with(subscription: Subscription.first || Subscription.new(email: "preview@example.ru")).welcome
  end
end
