json.data @invoices do |invoice|
  json.partial! 'invoice', invoice: invoice
end

json.meta do
  json.page        @invoices.current_page
  json.per_page    @invoices.limit_value
  json.total       @invoices.total_count
  json.total_pages @invoices.total_pages
end
