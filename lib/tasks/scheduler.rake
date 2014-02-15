require 'instagram_listener.rb'
require 'popular_places.rb'
include InstagramListener
include PopularPlaces

task :listen_instagram => :environment do
  InstagramListener.script
end

task :update_popular_places => :environment do
  PopularPlaces.update_popular_places
end

task :call_page => :environment do
   uri = URI.parse('http://eatme.heroku.com/')
   Net::HTTP.get(uri)
end
