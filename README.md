# Multi-Tenant Subscription Billing API

A Ruby on Rails API-only application for a SaaS platform where companies can manage projects, record usage events, and generate monthly usage-based invoices.

## Requirements

- Ruby 2.7.2
- PostgreSQL 9.3+
- Bundler

## Setup

```bash
# Install dependencies
bundle install

# Database setup
bundle exec rails db:create db:migrate db:seed
```

## Running the server

```bash
bundle exec rails server
```

## Running the test suite

```bash
bundle exec rspec
```

## API Endpoints

### Authentication

```
POST /api/v1/auth/login
Body: { "email": "...", "password": "..." }
Response: { "token": "...", "user": { ... } }
```

All other endpoints require `Authorization: Bearer <token>` header.

### Projects

```
GET    /api/v1/projects                     ?page=1&per_page=20
POST   /api/v1/projects                     Body: { "project": { "name": "...", "description": "..." } }
PATCH  /api/v1/projects/:id                 Body: { "project": { "name": "..." } }
DELETE /api/v1/projects/:id                 Soft deletes the project (returns 204)
```

GET returns `{ data: [...], meta: { page, per_page, total, total_pages } }`.

### Usage Events

```
POST /api/v1/projects/:project_id/usage_events
Body: { "usage_event": { "event_type": "api_call", "quantity": 100, "metadata": {}, "occurred_at": "2026-05-15T10:00:00Z" } }
```

Valid `event_type` values: `api_call`

### Invoices (owner/admin only)

```
GET  /api/v1/companies/:company_id/invoices            ?page=1&per_page=20
POST /api/v1/companies/:company_id/invoices/generate   Body: { "month": "2026-05" }
```

GET returns `{ data: [...], meta: { page, per_page, total, total_pages } }`.

### Change Plan (owner/admin only)

```
POST /api/v1/companies/:id/change_plan
Body: { "plan_name": "pro" }   # starter | pro | enterprise
```

## Subscription Plans

| Plan       | Included Events | Extra Event Price |
|------------|----------------|-------------------|
| Starter    | 1,000          | $0.02             |
| Pro        | 10,000         | $0.01             |
| Enterprise | 100,000        | $0.005            |

## User Roles

- **owner** / **admin** — can generate invoices and manage billing
- **member** — can create projects and record usage events

## Sample Seed Data

After `db:seed`, the following accounts are available:

- `owner@companya.com` / `password123` — Owner, Company A (Pro plan)
- `member@companya.com` / `password123` — Member, Company A
- `owner@companyb.com` / `password123` — Owner, Company B (Starter plan)

## Background Job

To generate invoices for all companies for a billing month:

```ruby
GenerateMonthlyInvoicesJob.perform_later('2026-05')
```

## Bonus Features Implemented

- **Soft delete for projects** — `DELETE /api/v1/projects/:id` sets `deleted_at`; soft-deleted projects are hidden from all listings
- **Pagination** — projects and invoices listings support `?page=` and `?per_page=` via kaminari
- **Change company plan** — `POST /api/v1/companies/:id/change_plan` updates the active subscription

## Assumptions

- `billing_month` is stored as the first day of the month (e.g., `2026-05-01` for May 2026)
- Invoice generation is idempotent: duplicate requests for the same company/month return the existing invoice
- Tenant isolation is enforced at the query level — users cannot access other companies' data by guessing IDs
- Usage events outside the billed month's date range are excluded from invoice calculation
- `event_type` is a Rails enum — adding new types requires only a model change, no migration
