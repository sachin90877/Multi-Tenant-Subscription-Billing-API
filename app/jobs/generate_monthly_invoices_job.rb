class GenerateMonthlyInvoicesJob < ApplicationJob
  queue_as :default

  def perform(billing_month_str)
    billing_month = Date.strptime(billing_month_str, '%Y-%m').beginning_of_month

    Company.find_each do |company|
      generate_for_company(company, billing_month)
    end
  end

  private

  def generate_for_company(company, billing_month)
    InvoiceGeneratorService.new(company, billing_month).call
  rescue StandardError => e
    Rails.logger.error("Failed to generate invoice for company #{company.id}: #{e.message}")
  end
end
