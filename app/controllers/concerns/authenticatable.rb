module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    @current_user = User.find_by(api_token: token) if token
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  end

  def current_user
    @current_user
  end

  def current_company
    @current_company ||= current_user.company
  end

  def require_billing_manager!
    render json: { error: 'Forbidden' }, status: :forbidden unless current_user.billing_manager?
  end
end
