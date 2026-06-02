Plan.create!([
  { name: 'starter',    included_events: 1000,   price_per_extra_event: 0.02  },
  { name: 'pro',        included_events: 10000,  price_per_extra_event: 0.01  },
  { name: 'enterprise', included_events: 100000, price_per_extra_event: 0.005 }
])

company_a = Company.create!(name: 'Company A')
company_b = Company.create!(name: 'Company B')

Subscription.create!(company: company_a, plan: Plan.find_by!(name: 'pro'),     status: 'active', started_at: Time.current)
Subscription.create!(company: company_b, plan: Plan.find_by!(name: 'starter'), status: 'active', started_at: Time.current)

User.create!(company: company_a, email: 'owner@companya.com',  password: 'password123', role: 'owner')
User.create!(company: company_a, email: 'member@companya.com', password: 'password123', role: 'member')
User.create!(company: company_b, email: 'owner@companyb.com',  password: 'password123', role: 'owner')
