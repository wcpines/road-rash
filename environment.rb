# require all your files and gems in one go
require 'bundler/setup'
Bundler.require


# set env var constants
CLIENT_URI = "http://127.0.0.1:9393"
CLIENT_ID = ENV["STRAVA_CLIENT_ID"]
CLIENT_SECRET = ENV["STRAVA_CLIENT_SECRET"]
SESSION_SECRET = ENV["SESSION_SECRET"]

# sinatra configurations
enable :sessions
set :session_secret, SESSION_SECRET
set(:views, 'app/views')
set :allow_origin, :any
set :allow_methods, [:post, :options]
set :expose_headers, ['Content-Type']

require_all('app/')
