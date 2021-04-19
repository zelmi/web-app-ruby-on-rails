json.extract! user, :id, :name, :created_at, :updated_at, :favorite_pet
json.url user_url(user, format: :json)
