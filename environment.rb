# require all your files and gems in one go
require 'bundler/setup'
Bundler.require

# set env var constants
CLIENT_URI = ENV["STRAVA_CLIENT_URI"]
CLIENT_ID = ENV["STRAVA_CLIENT_ID"]
CLIENT_SECRET = ENV["STRAVA_CLIENT_SECRET"]
SESSION_SECRET = ENV["SESSION_SECRET"]
REDIS_URL = ENV["REDIS_URL"] || "redis://localhost:6379"

# sinatra config
enable :sessions
set :session_secret, SESSION_SECRET
set :views, 'app/views'

# Redis config
uri = URI.parse(REDIS_URL)
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
Resque.redis = REDIS

require_all('app/')
