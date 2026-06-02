module Api
  module V1
    class CompaniesController < BaseController
      before_action :require_billing_manager!

      def change_plan
        unless params[:id].to_i == current_company.id
          return render json: { error: 'Forbidden' }, status: :forbidden
        end

        plan = Plan.find_by(name: params[:plan_name]&.downcase)

        unless plan
          return render json: { error: 'Plan not found. Valid plans: starter, pro, enterprise' }, status: :not_found
        end

        active_sub = current_company.active_subscription

        if active_sub
          active_sub.update!(plan: plan)
        else
          current_company.subscriptions.create!(plan: plan, status: 'active', started_at: Time.current)
        end

        render json: {
          company_id: current_company.id,
          plan: plan.name,
          included_events: plan.included_events,
          price_per_extra_event: plan.price_per_extra_event.to_f
        }
      end
    end
  end
end
