require "bundler/gem_tasks"

LIB_DIR = File.join(File.dirname(__FILE__), "lib")

desc 'set load path and require the gem'
task :environment do
  $LOAD_PATH.unshift(LIB_DIR)
  require 'wcc/arena'
end

desc 'open an IRB session with environment loaded'
task :irb => :environment do
  require 'irb'
  ARGV.clear
  IRB.start
end

