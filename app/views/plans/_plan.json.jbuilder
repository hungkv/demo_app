json.extract! plan, :id, :name, :price, :max_project, :max_storage, :max_upload, :integer, :created_at, :updated_at
json.url plan_url(plan, format: :json)
