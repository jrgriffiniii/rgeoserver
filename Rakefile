require 'rubygems'
require 'bundler'
require 'bundler/gem_tasks'
# require 'version_bumper'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

# Get your spec rake tasks working in RSpec 2.0

begin
  require 'rspec/core/rake_task'

  namespace :spec do
    desc 'Run unit tests'
    RSpec::Core::RakeTask.new(:unit) do |t|
      t.pattern = 'spec/{unit,utils}/**/*_spec.rb'
    end

    desc 'Run functional tests which requires GeoServer running'
    RSpec::Core::RakeTask.new(:functional) do |t|
      t.pattern = 'spec/functional/**/*_spec.rb'
    end

    desc 'Run integration tests which requires GeoServer running'
    RSpec::Core::RakeTask.new(:integration) do |t|
      t.pattern = 'spec/integration/**/*_spec.rb'
    end

    # desc 'Run integration tests which requires GeoServer running and preloaded'
    # RSpec::Core::RakeTask.new(:integration, :jetty_home, :jetty_port, :java_opts) do |t, args|
      # t.pattern = 'spec/integration/**/*_spec.rb'
      # require 'jettywrapper'
      # jetty_params = {
        # :jetty_home => args.jetty_home,
        # :java_opts => [args.java_opts],
        # :jetty_port => args.jetty_port,
        # :quiet => true,
        # :startup_wait => 20
      # }
  #
      # fail if Jettywrapper.wrap(jetty_params) do
        # Rake::Task['spec:integration'].invoke
      # end
    # end
  end

  desc 'Run all tests'
  task :spec => [ 'spec:unit', 'spec:functional', 'spec:integration' ]

  task :default => 'spec:unit'
rescue LoadError
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.options = ["--readme", "README.rdoc"]
  end
rescue LoadError
end

desc "Open an pry session preloaded with this library"
task :console do
  begin
    require 'pry'
    sh 'pry -I lib -r rgeoserver'
  rescue LoadError
  end
end
