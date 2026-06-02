FactoryBot.define do
  factory :plan do
    sequence(:name) { |n| "plan_#{n}" }
    included_events { 1_000 }
    price_per_extra_event { 0.02 }

    trait :starter do
      name { 'starter' }
      included_events { 1_000 }
      price_per_extra_event { 0.02 }
    end

    trait :pro do
      name { 'pro' }
      included_events { 10_000 }
      price_per_extra_event { 0.01 }
    end

    trait :enterprise do
      name { 'enterprise' }
      included_events { 100_000 }
      price_per_extra_event { 0.005 }
    end
  end
end
