# ユーザー検索結果を配列に格納
json.array! @users do |user|
  json.id       user.id
  json.name     user.name
  json.state    user.status.state
end