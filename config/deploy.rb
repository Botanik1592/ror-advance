# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "QNA"
set :repo_url, "git@github.com:Botanik1592/ror-advance.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/botan/qna"
set :deploy_user, 'botan'

# Default value for :linked_files is []
append :linked_files,
        "config/database.yml",
        "config/secrets.yml",
        ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log",
                     "tmp/pids",
                     "tmp/cache",
                     "tmp/sockets",
                     "public/system",
                     'public/uploads',
                     'db/sphinx'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
