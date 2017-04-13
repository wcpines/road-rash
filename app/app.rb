require_relative 'road_rash'
set(:views, 'app/views')

get '/' do
  erb :index
end

