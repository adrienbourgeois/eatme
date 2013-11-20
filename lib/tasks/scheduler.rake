require 'instagram_listener.rb'
include InstagramListener

task :listen_instagram => :environment do
  InstagramListener.script
end

