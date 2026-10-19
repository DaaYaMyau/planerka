module Admin
  class SubscriptionsController < BaseController
    def index
      @subscriptions = Subscription.order(created_at: :desc)
    end
  end
end
