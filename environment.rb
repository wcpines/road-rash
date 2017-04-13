# require all your files and gems in one go
require 'bundler/setup'
Bundler.require


# set env var constants
CLIENT_URI = "http://127.0.0.1:9393"
CLIENT_ID = ENV["STRAVA_CLIENT_ID"]
CLIENT_SECRET = ENV["STRAVA_CLIENT_SECRET"]

# look in correct dir for templates
set(:views, 'app/views')

require_all('app/')
