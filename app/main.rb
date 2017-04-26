require 'sinatra/cross_origin'

get '/' do
  erb :index
end

post '/login' do
  url = "https://www.strava.com/oauth/authorize?client_id=#{CLIENT_ID}"\
    "&response_type=code"\
    "&redirect_uri=#{CLIENT_URI}/export"\
    "&scope=view_private"\
    "&state=authorized"\
    "&approval_prompt=auto"
  redirect to(url)
end

get '/export'do
  code = request.params["code"]
  access_data = Strava::Api::V3::Auth.retrieve_access(CLIENT_ID, CLIENT_SECRET, code)
  session["token"] = access_data["access_token"]
  session["email"] = access_data["athlete"]["email"]
  session["firstname"] = access_data["athlete"]["firstname"]
  erb :export
end

options '/export' do
  cross_origin
  response.headers["Allow"] = "HEAD,POST,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Origin, Accept"
  response["Access-Control-Allow-Origin"] = "*"
  200
end

post '/export' do
  cross_origin
  token = session["token"]
  email_address = session["email"]
  name = session["firstname"]
  Courier.test(email_address, name, token)
  # Resque.enqueue(Courier, email_address, name, token)
end
