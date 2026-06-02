json.data @projects do |project|
  json.partial! 'project', project: project
end

json.meta do
  json.page        @projects.current_page
  json.per_page    @projects.limit_value
  json.total       @projects.total_count
  json.total_pages @projects.total_pages
end
