class ApplicationController < ActionController::API
  def routing_error
    render json: { error: 'Not found' }, status: :not_found
  end
end
