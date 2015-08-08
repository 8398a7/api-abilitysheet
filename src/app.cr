require "amethyst"
require "pg"

DB = PG.connect("postgres://abilitysheet-iidx@localhost:5432/abilitysheet-iidx_production")

class UsersController < Base::Controller
  actions :registered, :recent200

  def registered
    result = DB.exec({Int32}, "SELECT count(id) FROM users")
    hash = Hash(String, Int32).new
    hash["users"] = result.rows[0].to_a.first
    json hash.to_json
  end

  def recent200
    users = DB.exec({Int32}, "SELECT users.id FROM users, scores WHERE users.id = scores.user_id AND scores.state != 7 ORDER BY scores.updated_at DESC LIMIT 6400")

    hash = Hash(String | Int32, String).new

    recent_users = Array(Int32).new
    users.rows.each do |row|
      recent_users.push row.first unless recent_users.index(row.first)
      break if 200 <= recent_users.length
    end
    recent_users.uniq!

    ret = Array(Hash(String, String)).new
    recent_users.each do |ru|
      info = DB.exec("SELECT users.djname, users.iidxid, users.pref, scores.updated_at, scores.state, users.grade, sheets.title FROM users, scores, sheets WHERE users.id = #{ru} AND users.id = scores.user_id AND sheets.id = scores.sheet_id AND scores.state != 7 ORDER BY scores.updated_at desc LIMIT 1")
      row = info.rows[0]
      ret.push({"id": ru.to_s, "djname": row[0].to_s, "iidxid": row[1].to_s, "pref": row[2].to_s, "updated_at": row[3].to_s, "state": row[4].to_s, "grade": row[5].to_s, "title": row[6].to_s})
    end

    json ret.to_json
  end
end

class ApiAbilitySheet < Base::App
  settings.configure do |conf|
    conf.environment = "production"
  end

  routes.draw do
    get "/api/v1/users/registered", "users#registered"
    get "/api/v1/users/recent200", "users#recent200"
    register UsersController
  end

  use Middleware::TimeLogger
end

app = ApiAbilitySheet.new
app.serve
