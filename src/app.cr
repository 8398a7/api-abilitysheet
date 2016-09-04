require "kemal"
require "json"
require "pg"
require "dotenv"

Dotenv.load

config = Kemal.config
config.env = "production"
config.port = 8080

connection = PG.connect(ENV["DB_URL"])

get "/users/recent200" do |env|
  env.response.content_type = "application/json"
  query = "SELECT users.id, users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title FROM users, scores, sheets WHERE users.id = scores.user_id AND scores.state != 7 AND sheets.id = scores.sheet_id ORDER BY scores.updated_at DESC LIMIT 6400"
  users = connection.exec({Int32, String, String, Int32, Time, Int32, Int32, String}, query)

  recent_users = Array(Int32).new
  ret = Array(
    NamedTuple(
      id: Int32, djname: String, iidxid: String, pref: Int32,
      updated_at: String, state: Int32, grade: Int32, title: String
    )
  ).new
  users.not_nil!.each do |row|
    break if 200 <= recent_users.size
    next if recent_users.index(row[0])
    recent_users.push(row[0])
    ret.push({
      id: row[0], djname: row[1], iidxid: row[2], pref: row[3], updated_at: row[4].to_s.split[0],
      state: row[5], grade: row[6], title: row[7]
    })
  end
  ret.to_json
end

get "/users/count" do |env|
  env.response.content_type = "application/json"
  result = connection.exec({ Int64 }, "SELECT count(id) FROM users")

  { users: result.rows[0][0] }.to_json
end

get "/sheets" do |env|
  env.response.content_type = "application/json"
  sheets = Array(
    NamedTuple(id: Int32, title: String, n_ability: Int32, h_ability: Int32)
  ).new
  query = "SELECT sheets.id, sheets.title, sheets.n_ability, sheets.h_ability FROM sheets WHERE sheets.active = true ORDER BY sheets.id"
  results = connection.exec({ Int32, String, Int32, Int32 }, query)

  results.rows.not_nil!.each do |row|
    sheets.push({ id: row[0], title: row[1], n_ability: row[2], h_ability: row[3] })
  end
  sheets.to_json
end

Kemal.run
