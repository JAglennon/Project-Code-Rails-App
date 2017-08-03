json.extract! parent, :id, :name, :phone, :email, :created_at, :updated_at
json.url parent_url(parent, format: :json)