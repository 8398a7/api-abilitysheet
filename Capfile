require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

Dir.glob('config/tasks/*.rake').each { |r| import r }
