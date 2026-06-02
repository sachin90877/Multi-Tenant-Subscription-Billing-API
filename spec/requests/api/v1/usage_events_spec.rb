require 'rails_helper'

RSpec.describe 'Usage Events API', type: :request do
  let!(:company_a) { create(:company) }
  let!(:company_b) { create(:company) }
  let!(:member)    { create(:user, :member, company: company_a) }
  let!(:project_a) { create(:project, company: company_a) }
  let!(:project_b) { create(:project, company: company_b) }

  let(:valid_params) do
    {
      usage_event: {
        event_type: 'api_call',
        quantity: 5,
        metadata: { source: 'web' },
        occurred_at: Time.current
      }
    }
  end

  describe 'POST /api/v1/projects/:project_id/usage_events' do
    it 'returns 401 without a token' do
      post "/api/v1/projects/#{project_a.id}/usage_events", params: valid_params
      expect(response).to have_http_status(:unauthorized)
    end

    it 'creates a usage event for own project' do
      post "/api/v1/projects/#{project_a.id}/usage_events",
        params: valid_params,
        headers: auth_headers(member)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['quantity']).to eq(5)
      expect(json['event_type']).to eq('api_call')
    end

    it 'returns 422 for zero quantity' do
      post "/api/v1/projects/#{project_a.id}/usage_events",
        params: { usage_event: valid_params[:usage_event].merge(quantity: 0) },
        headers: auth_headers(member)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns 422 for negative quantity' do
      post "/api/v1/projects/#{project_a.id}/usage_events",
        params: { usage_event: valid_params[:usage_event].merge(quantity: -1) },
        headers: auth_headers(member)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns 422 for invalid event_type' do
      post "/api/v1/projects/#{project_a.id}/usage_events",
        params: { usage_event: valid_params[:usage_event].merge(event_type: 'unknown') },
        headers: auth_headers(member)

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns 404 for another company project' do
      post "/api/v1/projects/#{project_b.id}/usage_events",
        params: valid_params,
        headers: auth_headers(member)

      expect(response).to have_http_status(:not_found)
    end
  end
end
