require "kemal"
require "json"
require "kemal-pg"

config = Kemal.config
config.env = "production"

DB_URL = File.read("./.env").chomp
pg_connect DB_URL

get "/users/recent200" do |env|
  env.response.content_type = "application/json"
  users = conn.exec({Int32, String, String, Int32, Time, Int32, Int32, String}, "SELECT users.id, users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title  FROM users, scores, sheets WHERE users.id = scores.user_id AND scores.state != 7 AND sheets.id = scores.sheet_id ORDER BY scores.updated_at DESC LIMIT 6400")
  release

  recent_users = Array(Int32).new
  ret = Array(Hash(String, String)).new
  users.rows.each do |row|
    break if 200 <= recent_users.size
    next if recent_users.index(row[0])
    recent_users.push row[0]
    ret.push({ "id": row[0].to_s, "djname": row[1], "iidxid": row[2], "pref": row[3].to_s, "updated_at": row[4].to_s.split[0], "state": row[5].to_s, "grade": row[6].to_s, "title": row[7] })
  end

  ret.to_json
end

get "/users/count" do |env|
  env.response.content_type = "application/json"
  result = conn.exec({Int64}, "SELECT count(id) FROM users")
  release
  hash = Hash(String, Int64).new
  hash["users"] = result.rows[0].to_a.first
  hash.to_json
end

get "/sheets" do |env|
  env.response.content_type = "application/json"
  sheets = Array(Hash(String, String)).new
  results = conn.exec({Int32, String, Int32, Int32}, "SELECT sheets.id, sheets.title, sheets.n_ability, sheets.h_ability FROM sheets WHERE sheets.active = true ORDER BY sheets.id")
  release
  results.rows.each do |row|
    sheets.push({ "id": row[0].to_s, "title": row[1], "n_ability": row[2].to_s, "h_ability": row[3].to_s })
  end
  sheets.to_json
end
