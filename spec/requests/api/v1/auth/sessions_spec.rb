require 'rails_helper'

RSpec.describe 'POST /api/v1/auth/login', type: :request do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company, email: 'test@example.com', password: 'password123') }

  it 'returns a token with valid credentials' do
    post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'password123' }

    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json['token']).to eq(user.api_token)
    expect(json['user']['email']).to eq('test@example.com')
  end

  it 'returns 401 for wrong password' do
    post '/api/v1/auth/login', params: { email: 'test@example.com', password: 'wrong' }
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns 401 for unknown email' do
    post '/api/v1/auth/login', params: { email: 'nobody@example.com', password: 'password123' }
    expect(response).to have_http_status(:unauthorized)
  end
end
