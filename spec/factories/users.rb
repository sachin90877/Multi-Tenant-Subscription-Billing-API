FactoryBot.define do
  factory :user do
    company
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    role { 'member' }

    trait :owner do
      role { 'owner' }
    end

    trait :admin do
      role { 'admin' }
    end

    trait :member do
      role { 'member' }
    end
  end
end
