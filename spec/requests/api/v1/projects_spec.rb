require 'rails_helper'

RSpec.describe 'Projects API', type: :request do
  let!(:company_a) { create(:company) }
  let!(:company_b) { create(:company) }
  let!(:member) { create(:user, :member, company: company_a) }
  let!(:owner)  { create(:user, :owner,  company: company_a) }

  describe 'GET /api/v1/projects' do
    let!(:project_a) { create(:project, company: company_a) }
    let!(:project_b) { create(:project, company: company_b) }

    it 'returns 401 without a token' do
      get '/api/v1/projects'
      expect(response).to have_http_status(:unauthorized)
    end

    context 'with valid token' do
      it 'returns only the current company projects' do
        get '/api/v1/projects', headers: auth_headers(member)

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        ids = json['data'].map { |p| p['id'] }
        expect(ids).to include(project_a.id)
        expect(ids).not_to include(project_b.id)
        expect(json['meta']).to include('page', 'per_page', 'total')
      end

      it 'does not return soft-deleted projects' do
        project_a.soft_delete!
        get '/api/v1/projects', headers: auth_headers(member)

        ids = JSON.parse(response.body)['data'].map { |p| p['id'] }
        expect(ids).not_to include(project_a.id)
      end
    end
  end

  describe 'POST /api/v1/projects' do
    it 'creates a project for the current company' do
      post '/api/v1/projects',
        params: { project: { name: 'New Project', description: 'desc' } },
        headers: auth_headers(member)

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['name']).to eq('New Project')
      expect(json['company_id']).to eq(company_a.id)
    end

    it 'returns 422 with a missing name' do
      post '/api/v1/projects',
        params: { project: { name: '' } },
        headers: auth_headers(member)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH /api/v1/projects/:id' do
    let!(:project) { create(:project, company: company_a) }
    let!(:other_project) { create(:project, company: company_b) }

    it 'updates own company project' do
      patch "/api/v1/projects/#{project.id}",
        params: { project: { name: 'Updated' } },
        headers: auth_headers(member)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq('Updated')
    end

    it 'returns 404 for another company project' do
      patch "/api/v1/projects/#{other_project.id}",
        params: { project: { name: 'Hacked' } },
        headers: auth_headers(member)

      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE /api/v1/projects/:id' do
    let!(:project) { create(:project, company: company_a) }

    it 'soft deletes the project' do
      delete "/api/v1/projects/#{project.id}", headers: auth_headers(member)

      expect(response).to have_http_status(:no_content)
      expect(project.reload.deleted_at).not_to be_nil
    end

    it 'returns 404 for another company project' do
      other_project = create(:project, company: company_b)
      delete "/api/v1/projects/#{other_project.id}", headers: auth_headers(member)

      expect(response).to have_http_status(:not_found)
    end

    it 'hides the project from index after deletion' do
      delete "/api/v1/projects/#{project.id}", headers: auth_headers(member)
      get '/api/v1/projects', headers: auth_headers(member)

      ids = JSON.parse(response.body)['data'].map { |p| p['id'] }
      expect(ids).not_to include(project.id)
    end
  end
end
