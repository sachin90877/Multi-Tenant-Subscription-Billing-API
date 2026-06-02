class InvoiceGeneratorService
  def initialize(company, billing_month)
    @company = company
    @billing_month = billing_month
  end

  def call
    existing = @company.invoices.find_by(billing_month: @billing_month)
    return { success: true, invoice: existing, created: false } if existing

    plan = @company.active_plan

    unless plan
      return { success: false, error: 'Company has no active subscription plan' }
    end

    total_events    = calculate_total_events
    billable_events = [total_events - plan.included_events, 0].max
    amount          = plan.calculate_amount(total_events)

    invoice = @company.invoices.create!(
      billing_month:   @billing_month,
      total_events:    total_events,
      included_events: plan.included_events,
      billable_events: billable_events,
      amount:          amount,
      generated_at:    Time.current
    )

    { success: true, invoice: invoice, created: true }
  rescue ActiveRecord::RecordNotUnique
    existing = @company.invoices.find_by!(billing_month: @billing_month)
    { success: true, invoice: existing, created: false }
  end

  private

  def calculate_total_events
    period_start = Time.utc(@billing_month.year, @billing_month.month, 1)
    period_end   = period_start.end_of_month

    UsageEvent
      .joins(:project)
      .where(projects: { company_id: @company.id, deleted_at: nil })
      .where(occurred_at: period_start..period_end)
      .sum(:quantity)
  end
end
