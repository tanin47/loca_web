set :stages, %w(staging production)
set :default_stage, "staging"

set :domain, "46.137.213.161"
require 'capistrano/ext/multistage'

set :application, "loca"
set :repository,  "git@github.com:tanin47/loca_web.git"

set :use_sudo,    false
set :scm,         "git"
set :git_enable_submodules,1

set :user, "deploy"


role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :shared_assets, ['public/uploads','tmp']

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
   task :start do ; end
   task :stop do ; end
   
   desc "Restart Rails app"
   task :restart, :roles => :app, :except => { :no_release => true } do
      run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
end
 


namespace :assets  do
  namespace :symlinks do

    desc "Link assets for current deploy to the shared location"
    task :update, :roles => [:app, :web] do
      shared_assets.each { |link|
        begin 
          run "mkdir -p #{shared_path}/#{link} && chmod 777 #{release_path}/#{link}" 
        rescue
        end

        run "rm -rf #{release_path}/#{link}" 
        run "chmod 777 #{shared_path}/#{link} && ln -s #{shared_path}/#{link} #{release_path}/#{link}" 

      }
    end

    task :precompile, :roles => [:app, :web] do
      run "cd #{release_path}; rake assets:precompile RAILS_ENV=production"
    end

  end
end



namespace :bundler do
  task :create_symlink, :roles => :app do
    shared_dir = File.join(shared_path, 'bundle')
    release_dir = File.join(current_release, 'vendor/bundle')
    run("mkdir -p #{shared_dir} && ln -nfs #{shared_dir} #{release_dir}")
  end
 
  task :bundle_new_release, :roles => :app do
    bundler.create_symlink
    shared_dir = File.join(shared_path, 'bundle')
    run "cd #{release_path} && bundle install --path vendor/bundle"
  end
end


# add this to config/deploy.rb
namespace :delayed_job do
  desc "Start delayed_job process"

  task :start do
    run "chmod 755 #{current_path}/script/delayed_job"
    run "RAILS_ENV=production #{current_path}/script/delayed_job start"
  end

  task :stop do
    run "chmod 755 #{current_path}/script/delayed_job"
    run "RAILS_ENV=production #{current_path}/script/delayed_job stop" 
  end

end

before "deploy" do 
  delayed_job.stop
end

after "deploy" do
  delayed_job.start
end

after "deploy:update_code" do
  bundler.bundle_new_release
  assets.symlinks.precompile
  assets.symlinks.update
end






 

