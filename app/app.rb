ACCESS_TOKEN ||= ''

get '/' do
  if request.params["state"] && request.params["state"] == "authorized"
    code = request.params["code"]
    access_data = Strava::Api::V3::Auth.retrieve_access(CLIENT_ID, CLIENT_SECRET, code)
    ACCESS_TOKEN = access_data["access_token"]
    redirect to('/export')
  else
    erb :index
  end
end

get '/export'do
  erb :export
end


post '/login' do
  url = "https://www.strava.com/oauth/authorize?client_id=#{CLIENT_ID}"\
    "&response_type=code"\
    "&redirect_uri=#{CLIENT_URI}"\
    "&scope=view_private"\
    "&state=authorized"\
    "&approval_prompt=force"
  redirect to(url)
end
