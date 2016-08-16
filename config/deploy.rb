lock '3.6.0'

set :application, 'api-abilitysheet'
set :repo_url, 'https://github.com/8398a7/api-abilitysheet.git'

set :deploy_to, '/var/www/app/api-abilitysheet'

set :pty, true
append :linked_files, '.env', 'kemal.log'

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
  task :write_logs do
    on roles(:app) do
      execute "docker logs api-abilitysheet >> #{shared_path}/kemal.log; exit 0"
    end
  end
  task :remove do
    on roles(:app) do
      execute 'echo api-abilitysheet|xargs docker stop|xargs docker rm; exit 0'
    end
  end
  task :run do
    on roles(:app) do
      execute 'docker run -d -p 8080:8080 --name=api-abilitysheet abilitysheet'
    end
  end

  before 'symlink:release', :build
  after :build, :write_logs
  after :write_logs, :remove
  after :remove, :run
end

namespace :logs do
  task :show do
    on roles(:app) do
      puts capture 'docker logs api-abilitysheet'
    end
  end
end
