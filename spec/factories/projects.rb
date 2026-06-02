FactoryBot.define do
  factory :project do
    company
    sequence(:name) { |n| "Project #{n}" }
    description { 'A test project' }
  end
end
