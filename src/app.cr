require "amethyst"
require "pg"

DB = PG.connect("postgres://abilitysheet-iidx@localhost:5432/abilitysheet-iidx_production")

class UsersController < Base::Controller
  actions :registered

  def registered
    result = DB.exec({Int32}, "SELECT count(id) FROM users")
    hash = Hash(String, Int32).new
    hash["users"] = result.rows[0].to_a.first
    json hash.to_json
  end
end

class ApiAbilitySheet < Base::App
  routes.draw do
    get "/api/v1/users/registered", "users#registered"
    register UsersController
  end
end


app = ApiAbilitySheet.new
app.serve
