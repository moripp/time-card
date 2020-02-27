json.array! @users do |user|
  json.id       user.id
  json.name     user.name
  json.state    user.status.state
end