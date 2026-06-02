FactoryBot.define do
  factory :usage_event do
    project
    event_type { 'api_call' }
    quantity { 10 }
    metadata { { source: 'web' } }
    occurred_at { Time.current }
  end
end
