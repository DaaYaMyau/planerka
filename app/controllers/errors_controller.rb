class ErrorsController < ApplicationController
  skip_before_action :teaser_gate, raise: false

  def not_found
    render status: :not_found, formats: :html
  end
end
