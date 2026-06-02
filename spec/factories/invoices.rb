FactoryBot.define do
  factory :invoice do
    company
    billing_month { Date.today.beginning_of_month }
    total_events { 0 }
    included_events { 1_000 }
    billable_events { 0 }
    amount { 0 }
    generated_at { Time.current }
  end
end
