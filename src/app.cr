require "amethyst"
require "pg"

DB_URL = File.read("./.env").chomp

DB = PG.connect(DB_URL)

class UsersController < Base::Controller
  actions :registered, :recent200

  def registered
    result = DB.exec({Int32}, "SELECT count(id) FROM users")
    hash = Hash(String, Int32).new
    hash["users"] = result.rows[0].to_a.first
    json hash.to_json
  end

  def recent200
    users = DB.exec({Int32, String, String, Int32, Time, Int32, Int32, String}, "SELECT users.id, users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title  FROM users, scores, sheets WHERE users.id = scores.user_id AND scores.state != 7 AND sheets.id = scores.sheet_id ORDER BY scores.updated_at DESC LIMIT 6400")

    recent_users = Array(Int32).new
    ret = Array(Hash(String, String)).new
    users.rows.each do |row|
      break if 200 <= recent_users.length
      next if recent_users.index(row[0])
      recent_users.push row[0]
      ret.push({ "id": row[0].to_s, "djname": row[1], "iidxid": row[2], "pref": row[3].to_s, "updated_at": row[4].to_s.split[0], "state": row[5].to_s, "grade": row[6].to_s, "title": row[7] })
    end

    json ret.to_json
  end
end

class ApiAbilitySheet < Base::App
  settings.configure do |conf|
    conf.environment = "production"
  end

  routes.draw do
    get "/v1/users/registered", "users#registered"
    get "/v1/users/recent200", "users#recent200"
    register UsersController
  end

  use Middleware::TimeLogger
end

app = ApiAbilitySheet.new
app.serve
