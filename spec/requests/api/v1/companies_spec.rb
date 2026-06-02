require 'rails_helper'

RSpec.describe 'Companies API', type: :request do
  let!(:starter) { create(:plan, :starter) }
  let!(:pro)     { create(:plan, :pro) }
  let!(:company) { create(:company) }
  let!(:sub)     { create(:subscription, company: company, plan: starter) }
  let!(:owner)   { create(:user, :owner, company: company) }
  let!(:member)  { create(:user, :member, company: company) }

  describe 'POST /api/v1/companies/:id/change_plan' do
    it 'allows owner to change the plan' do
      post "/api/v1/companies/#{company.id}/change_plan",
        params: { plan_name: 'pro' },
        headers: auth_headers(owner)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['plan']).to eq('pro')
      expect(sub.reload.plan_id).to eq(pro.id)
    end

    it 'returns 403 for a member' do
      post "/api/v1/companies/#{company.id}/change_plan",
        params: { plan_name: 'pro' },
        headers: auth_headers(member)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 404 for an invalid plan name' do
      post "/api/v1/companies/#{company.id}/change_plan",
        params: { plan_name: 'nonexistent' },
        headers: auth_headers(owner)

      expect(response).to have_http_status(:not_found)
    end

    it 'returns 403 for another company owner' do
      other_company = create(:company)
      other_owner   = create(:user, :owner, company: other_company)

      post "/api/v1/companies/#{company.id}/change_plan",
        params: { plan_name: 'pro' },
        headers: auth_headers(other_owner)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
