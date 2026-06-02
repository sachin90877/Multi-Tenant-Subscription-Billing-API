module Api
  module V1
    class ProjectsController < BaseController
      def index
        @projects = current_company.projects
                                   .order(created_at: :desc)
                                   .page(params[:page]).per(page_size)
      end

      def create
        project = current_company.projects.build(project_params)

        if project.save
          render json: project, status: :created
        else
          render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        project = current_company.projects.find(params[:id])

        if project.update(project_params)
          render json: project
        else
          render json: { errors: project.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        project = current_company.projects.find(params[:id])
        project.soft_delete!
        head :no_content
      end

      private

      def project_params
        params.require(:project).permit(:name, :description)
      end
    end
  end
end
