def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end
set :application, "metrics"
require "bundler/capistrano"
require 'capistrano/maintenance'
require 'sidekiq/capistrano'
require "whenever/capistrano"

default_run_options[:pty] = true
require 'capistrano-rbenv'
default_run_options[:shell] = '/bin/bash --login'
set :copy_exclude, [".git"]
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby_version, '2.1.1'
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :repository,  "/path/to/repo/.git"
set :local_repository, "/path/to/repo/.git"

server "0.0.0.0", :app, :web, :db, :primary => true
set :deploy_via, :copy
set :scm, :git
set :branch, 'master'
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :deploy_to, "/path/to/app"
set :user, "deploy"
set :use_sudo, false
# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"
set_default(:puma_pid) { "#{shared_path}/puma/pid" }
set_default(:puma_log) { "#{shared_path}/log/puma-production.log" }
before "deploy:restart", "deploy:link_secrets"

namespace :deploy do
  task :link_figaro do
    run "ln -nfs #{deploy_to}/shared/application.yml #{deploy_to}/current/config/application.yml"
  end
  task :link_secrets do
    run "ln -nfs #{deploy_to}/shared/secrets.yml #{deploy_to}/current/config/secrets.yml"
  end
end
namespace :setup do
  desc "Uploads config/application.yml"
  task :figaro do
    ENV["FILES"] = 'config/application.yml'
    deploy.upload
    run "mv #{deploy_to}/current/config/application.yml #{deploy_to}/shared/"
  end

  desc "Uploads config/secrets.yml"
  task :secrets do
    ENV["FILES"] = 'config/secrets.yml'
    deploy.upload
    run "mv #{deploy_to}/current/config/secrets.yml #{deploy_to}/shared/"
  end
end


namespace :puma do
  desc "Start Puma"
  task :start, :except => { :no_release => true } do
    commands = ["cd #{current_path};"]
    commands << "bundle exec puma"
    commands << "-C config/puma.rb"
    run commands.join(" ") + " >> #{puma_log} 2>&1 &", :pty => false
  end
  after "deploy:start", "puma:start"

  desc "Stop Puma"
  task :stop, :except => { :no_release => true } do
    run "kill -9 `cat #{puma_pid}`"
  end
  after "deploy:stop", "puma:stop"

  desc "Restart Puma"
  task :restart, roles: :app do
    begin
      run "kill -s SIGUSR2 `cat #{puma_pid}`"
    rescue
      puma.start
    end
  end
  after "deploy:restart", "puma:restart"
end


desc "Clear logs"
task :clear_logs do
  run "cd #{current_path} && bundle exec rake log:clear"
end

