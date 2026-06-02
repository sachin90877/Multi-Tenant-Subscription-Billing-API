module Api
  module V1
    class InvoicesController < BaseController
      before_action :require_billing_manager!
      before_action :authorize_company!

      def index
        @invoices = current_company.invoices
                                   .order(billing_month: :desc)
                                   .page(params[:page]).per(page_size)
      end

      def generate
        billing_month = parse_billing_month(params[:month])
        return render json: { error: 'month is required in YYYY-MM format' }, status: :bad_request unless billing_month

        result = InvoiceGeneratorService.new(current_company, billing_month).call

        if result[:success]
          @invoice = result[:invoice]
          render status: result[:created] ? :created : :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      private

      def authorize_company!
        render json: { error: 'Forbidden' }, status: :forbidden unless params[:company_id].to_i == current_company.id
      end

      def parse_billing_month(month_str)
        Date.strptime(month_str.to_s, '%Y-%m').beginning_of_month
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end
