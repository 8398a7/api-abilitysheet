namespace :logs do
  task :show do
    on roles(:app) do
      puts capture 'docker logs api-abilitysheet'
    end
  end
end
