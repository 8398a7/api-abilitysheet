lock '3.6.0'

set :application, 'api-abilitysheet'
set :repo_url, 'https://github.com/8398a7/api-abilitysheet.git'

set :deploy_to, '/var/www/app/api-abilitysheet'

set :pty, true
append :linked_files, '.env'

set :default_env, path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
set :rbenv_type, :system

namespace :deploy do
  desc 'build abilitysheet'
  task :build do
    on roles(:app) do
      execute "cd #{release_path}; rm .env; cp ../../shared/.env ."
      execute "cd #{release_path}; docker build -t abilitysheet ."
    end
  end
  task :remove do
    on roles(:app) do
      res = capture 'docker ps'
      execute 'echo api-abilitysheet | xargs docker stop | xargs docker rm' if res.include?('api-abilitysheet')
    end
  end
  task :run do
    on roles(:app) do
      execute 'docker run -d -p 8080:8080 --name=api-abilitysheet abilitysheet'
    end
  end

  after 'symlink:linked_files', :build
  after :build, :remove
  after :remove, :run
end
