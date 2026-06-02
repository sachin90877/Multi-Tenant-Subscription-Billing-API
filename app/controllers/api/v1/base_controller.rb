module Api
  module V1
    class BaseController < ApplicationController
      include Authenticatable

      rescue_from ActiveRecord::RecordNotFound, with: :not_found

      private

      def not_found
        render json: { error: 'Not found' }, status: :not_found
      end

      def page_size
        [(params[:per_page] || 25).to_i, 100].min
      end
    end
  end
end
