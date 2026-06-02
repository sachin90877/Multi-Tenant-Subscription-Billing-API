FactoryBot.define do
  factory :subscription do
    company
    plan
    status { 'active' }
    started_at { Time.current }
  end
end
