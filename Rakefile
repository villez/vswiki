# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Vswiki::Application.load_tasks

# hack to work around an incompatibility with test:prepare being
# removed but rspec Rake tasks still referring to it

namespace :test do
  task prepare: :environment
end
