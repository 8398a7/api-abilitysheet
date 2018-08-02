set :branch, ENV['BRANCH'] || :master

server 'iidx12', user: 'deploy', roles: %w[web app db]

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: true,
  auth_methods: %w[publickey]
}
