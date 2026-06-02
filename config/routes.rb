Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :auth do
        post 'login', to: 'sessions#create'
      end

      resources :projects, only: [:index, :create, :update, :destroy] do
        resources :usage_events, only: [:create]
      end

      resources :companies, only: [] do
        resources :invoices, only: [:index] do
          collection do
            post :generate
          end
        end
        member do
          post :change_plan
        end
      end
    end
  end

  match '*path', to: 'application#routing_error', via: :all
end
