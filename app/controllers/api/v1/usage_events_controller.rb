module Api
  module V1
    class UsageEventsController < BaseController
      def create
        project = current_company.projects.find_by(id: params[:project_id])

        unless project
          return render json: { error: 'Not found' }, status: :not_found
        end

        event = project.usage_events.build(usage_event_params)

        if event.save
          render json: event, status: :created
        else
          render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ArgumentError => e
        render json: { errors: [e.message] }, status: :unprocessable_entity
      end

      private

      def usage_event_params
        permitted = params.require(:usage_event).permit(:event_type, :quantity, :occurred_at)
        permitted[:metadata] = params.dig(:usage_event, :metadata)&.to_unsafe_h
        permitted
      end
    end
  end
end
