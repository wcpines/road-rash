require_relative 'environment.rb'

use Rack::MethodOverride # see :MethodOverride http://www.sinatrarb.com/configuration.html
run Sinatra::Application
