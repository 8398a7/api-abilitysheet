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
  task :remove do
    on roles(:app) do
      execute 'echo api-abilitysheet|xargs docker stop|xargs docker rm; exit 0'
    end
  end
  task :run do
    on roles(:app) do
      execute "docker run -v $(pwd)/public:/app/public --rm --env-file #{shared_path}/.env -d -p 8080:8080 --name=api-abilitysheet abilitysheet"
    end
  end

  before 'symlink:release', :build
  after :build, :write_logs
  after :write_logs, :remove
  after :remove, :run
end
