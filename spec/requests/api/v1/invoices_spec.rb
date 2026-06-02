require 'rails_helper'

RSpec.describe 'Invoices API', type: :request do
  let!(:plan)      { create(:plan, :pro) }
  let!(:company_a) { create(:company) }
  let!(:company_b) { create(:company) }
  let!(:sub_a)     { create(:subscription, company: company_a, plan: plan) }
  let!(:owner)     { create(:user, :owner, company: company_a) }
  let!(:member)    { create(:user, :member, company: company_a) }
  let!(:project)   { create(:project, company: company_a) }

  describe 'GET /api/v1/companies/:company_id/invoices' do
    let!(:invoice) { create(:invoice, company: company_a) }

    it 'returns paginated invoices for own company' do
      get "/api/v1/companies/#{company_a.id}/invoices", headers: auth_headers(owner)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].map { |i| i['id'] }).to include(invoice.id)
      expect(json['meta']).to include('page', 'per_page', 'total', 'total_pages')
    end

    it 'returns 403 for another company' do
      owner_b = create(:user, :owner, company: company_b)
      get "/api/v1/companies/#{company_a.id}/invoices", headers: auth_headers(owner_b)
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 403 for a member' do
      get "/api/v1/companies/#{company_a.id}/invoices", headers: auth_headers(member)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /api/v1/companies/:company_id/invoices/generate' do
    it 'returns 401 without a token' do
      post "/api/v1/companies/#{company_a.id}/invoices/generate", params: { month: '2026-05' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 403 for a member' do
      post "/api/v1/companies/#{company_a.id}/invoices/generate",
        params: { month: '2026-05' },
        headers: auth_headers(member)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 403 for another company owner' do
      owner_b = create(:user, :owner, company: company_b)
      create(:subscription, company: company_b, plan: plan)

      post "/api/v1/companies/#{company_a.id}/invoices/generate",
        params: { month: '2026-05' },
        headers: auth_headers(owner_b)

      expect(response).to have_http_status(:forbidden)
    end

    it 'returns 400 for invalid month format' do
      post "/api/v1/companies/#{company_a.id}/invoices/generate",
        params: { month: 'not-a-date' },
        headers: auth_headers(owner)

      expect(response).to have_http_status(:bad_request)
    end

    it 'returns 400 when month is missing' do
      post "/api/v1/companies/#{company_a.id}/invoices/generate",
        headers: auth_headers(owner)

      expect(response).to have_http_status(:bad_request)
    end

    it 'calculates the invoice correctly' do
      create(:usage_event, project: project, quantity: 12500, occurred_at: Time.parse('2026-05-15'))

      post "/api/v1/companies/#{company_a.id}/invoices/generate",
        params: { month: '2026-05' },
        headers: auth_headers(owner)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['total_events']).to eq(12500)
      expect(json['included_events']).to eq(10000)
      expect(json['billable_events']).to eq(2500)
      expect(json['amount']).to eq(25.0)
      expect(json['billing_month']).to eq('2026-05')
    end

    it 'generates a zero-cost invoice when usage is within the plan limit' do
      create(:usage_event, project: project, quantity: 5000, occurred_at: Time.parse('2026-03-10'))

      post "/api/v1/companies/#{company_a.id}/invoices/generate",
        params: { month: '2026-03' },
        headers: auth_headers(owner)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['billable_events']).to eq(0)
      expect(json['amount']).to eq(0.0)
    end

    it 'is idempotent — returns the existing invoice on duplicate requests' do
      2.times do
        post "/api/v1/companies/#{company_a.id}/invoices/generate",
          params: { month: '2026-04' },
          headers: auth_headers(owner)
      end

      expect(response).to have_http_status(:ok)
      expect(company_a.invoices.where(billing_month: Date.parse('2026-04-01')).count).to eq(1)
    end
  end
end
