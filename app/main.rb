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
  erb :export
end


post '/export' do
  code = request.env["HTTP_REFERER"].split("&")[1].split("=")[1]
  access_data = Strava::Api::V3::Auth.retrieve_access(CLIENT_ID, CLIENT_SECRET, code)

  token = access_data["access_token"]
  email_address = access_data["athlete"]["email"]
  name = access_data["athlete"]["firstname"]

  Resque.enqueue(Courier, email_address, name, token)
end
