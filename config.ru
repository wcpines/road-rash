require 'bundler/setup'
Bundler.require

require_all('app/')


use Rack::MethodOverride # see :MethodOverride http://www.sinatrarb.com/configuration.html
run Sinatra::Application
