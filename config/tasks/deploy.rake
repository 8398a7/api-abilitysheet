namespace :deploy do
  desc 'build abilitysheet'
  task :build do
    on roles(:app) do
      execute "rm #{release_path}/.env; cp #{shared_path}/.env #{release_path}"
      execute "cd #{release_path}; docker build -t abilitysheet ."
    end
  end
  task :write_logs do
    on roles(:app) do
      execute "docker logs api-abilitysheet >> #{shared_path}/gin.log; exit 0"
    end
  end
  task :stop do
    on roles(:app) do
      execute 'docker stop api-abilitysheet'
    end
  end

  before 'symlink:release', :build
  after :build, :write_logs
  after :write_logs, :stop
end
