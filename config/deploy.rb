set :application, 'rlc'
set :repo_url, 'git@github.com:lordp/racingleaguecharts.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/rlc'
set :scm, :git

set :format, :pretty
set :log_level, :info
# set :pty, true

set :linked_files, %w{config/database.yml config/reddit.yml config/secrets.yml public/racingleaguecharts.exe public/version.xml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

#set :rbenv_type, :user # or :system, depends on your rbenv setup
#set :rbenv_ruby, '2.0.0-p353'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end

