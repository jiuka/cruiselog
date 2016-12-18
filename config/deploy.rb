# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'cruiselog'
set :repo_url, 'https://github.com/jiuka/cruiselog.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Temp Dir
set :tmp_dir, -> { "/home/#{fetch(:user)}/tmp" }

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  task :restart do
    on roles(:web) do |host|
      execute '/bin/systemctl --user restart puma'
      info "Host #{host} restart puma"
    end
  end

end

after "deploy", "deploy:restart"
