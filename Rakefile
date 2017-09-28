require "rake/testtask"

namespace :test do
  Rake::TestTask.new(:all) do |t|
    t.libs    = %w(lib test)
    t.pattern = 'test/**/*_test.rb'
    t.warning = false
  end

  # Adjust this array to suite our needs - below is an example
  # So we could run:  rake test:restAPI, rake test:jobs, and rake test:services
  %w(endpoints models services).each do |name|
    Rake::TestTask.new(name) do |t|
      t.libs = %W(lib/#{name} test test/#{name})
      t.pattern = "test/#{name}/**/*_test.rb"
      t.warning = false
    end
  end
end

task test: ["test:all"]
task :default => :test
