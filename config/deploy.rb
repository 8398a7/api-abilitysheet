lock '3.6.0'

set :application, 'api-abilitysheet'
set :repo_url, 'https://github.com/8398a7/api-abilitysheet.git'

set :deploy_to, '/var/www/app/api-abilitysheet'

set :pty, true
append :linked_files, '.env', 'kemal.log'

set :default_env, path: '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH'
set :rbenv_type, :system
