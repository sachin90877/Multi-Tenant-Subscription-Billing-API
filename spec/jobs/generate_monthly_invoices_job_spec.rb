require 'rails_helper'

RSpec.describe GenerateMonthlyInvoicesJob, type: :job do
  let!(:plan)    { create(:plan, :pro) }
  let!(:company) { create(:company) }
  let!(:sub)     { create(:subscription, company: company, plan: plan) }

  it 'generates invoices for all companies' do
    expect {
      GenerateMonthlyInvoicesJob.perform_now('2026-05')
    }.to change { company.invoices.count }.by(1)
  end

  it 'is idempotent — does not create duplicate invoices on retry' do
    2.times { GenerateMonthlyInvoicesJob.perform_now('2026-05') }
    expect(company.invoices.count).to eq(1)
  end
end
