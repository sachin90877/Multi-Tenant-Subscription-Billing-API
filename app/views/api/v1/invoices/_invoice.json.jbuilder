json.id            invoice.id
json.company_id    invoice.company_id
json.billing_month invoice.billing_month.strftime('%Y-%m')
json.total_events  invoice.total_events
json.included_events invoice.included_events
json.billable_events invoice.billable_events
json.amount        invoice.amount.to_f
json.generated_at  invoice.generated_at
