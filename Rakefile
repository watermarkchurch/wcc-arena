require "bundler/gem_tasks"
require "json"

PROJECT_PATH = File.dirname(__FILE__)
LIB_PATH = File.join(PROJECT_PATH, "lib")
CREDENTIALS_PATH = File.join(PROJECT_PATH, ".arena-creds")

desc 'set load path and require the gem'
task :environment do
  $LOAD_PATH.unshift(LIB_PATH)
  require 'wcc/arena'
end

desc 'open an IRB session with environment loaded'
task :irb => :environment do
  require 'irb'
  ARGV.clear
  IRB.start
end

desc 'point the library at the instance of Arena described in .arena-creds and launch irb'
task :arena => :environment do
  creds = JSON.parse(File.open(CREDENTIALS_PATH).read)
  WCC::Arena.configure do |arena|
    arena.username = creds['username']
    arena.password = creds['password']
    arena.api_key = creds['api_key']
    arena.api_secret = creds['api_secret']
    arena.api_url = creds['api_url']
  end
  $session = WCC::Arena::Session.new(
    username: WCC::Arena.config.username,
    password: WCC::Arena.config.password,
    api_key: WCC::Arena.config.api_key,
    api_secret: WCC::Arena.config.api_secret,
  )
  Rake::Task['irb'].invoke
end
