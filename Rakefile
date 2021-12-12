# frozen_string_literal: true

require 'rake/testtask'

CODE = 'lib/'

task :default do
  puts `rake -T`
end

desc 'Run unit and integration tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/tests/{integration,unit}/**/*_spec.rb'
  t.warning = false
end

desc 'Run application console (irb)'
task :console do
  sh 'pry -r ./init.rb'
end

desc 'run tests'
task :spec do
  sh 'ruby spec/gateway_youtube_spec.rb'
end

desc 'Keep rerunning unit/integration tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Run acceptance tests'
task :spec_accept do
  puts 'NOTE: run app in test environment in another process'
  sh 'ruby spec/tests/acceptance/acceptance_spec.rb'
end

desc 'Keep restarting web app upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :test do
  desc 'run tests (alias to: "rake spec")'
  task :spec do
    sh 'ruby spec/gateway_youtube_spec.rb'
  end

  desc 'run youtube api tests after deleting all VCR cassettes files'
  task :noVCR do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
    sh 'ruby spec/gateway_youtube_spec.rb'
  end

  desc 'Generate the correct answer for gateway-youtubeapi tests'
  task :youtubeapi_testcase do
    sh 'ruby spec/fixtures/generate_youtubeapi_testcase.rb'
  end
end

namespace :run do
  task :dev do
    sh 'rerun -c "rackup -p 9292"'
  end

  task :test do
    sh 'RACK_ENV=test rackup -p 9000'
  end
end

namespace :quality do
  only_app = 'config/ app/'

  desc 'run all static-analysis quality checks'
  task all: %i[rubocop flog reek]

  desc 'code style linter'
  task :rubocop do
    sh 'rubocop'
  end

  desc 'code smell detector'
  task :reek do
    sh 'reek'
  end

  desc 'complexiy analysis'
  task :flog do
    sh "flog -m #{only_app}"
  end
end
