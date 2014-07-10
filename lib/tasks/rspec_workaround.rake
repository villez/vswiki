# hack to work around an incompatibility with test:prepare being
# removed but rspec Rake tasks still referring to it

namespace :test do
  task prepare: :environment
end
