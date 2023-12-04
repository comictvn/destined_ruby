json.extract! @baseservice, :id, :created_at, :updated_at
json.health_check @baseservice.health_check
