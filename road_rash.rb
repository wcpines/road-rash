require 'byebug'
require 'strava/api/v3'
require 'csv'

@client = Strava::Api::V3::Client.new(:access_token => ENV["STRAVA_ACCESS_TOKEN"])

def format_data(rows, runs)
  rows << runs.map do |run|
    name = run["name"]
    miles = (run["distance"]/1600).round(2)
    minutes_duration = (run["moving_time"]/60).round(2)
    mile_pace = (1/(run["average_speed"]/1600 * 60)).round(2)
    date = DateTime.parse(run["start_date_local"]).strftime("%d/%m/%Y")
    time = DateTime.parse(run["start_date_local"]).strftime("%T")
    gear_row = get_gear(run)
    description = get_notes(run)
    [name, miles, minutes_duration, mile_pace, date, time, gear_row, description].flatten
  end
end

def get_gear(activity)
  if activity["gear_id"]
    gear = @client.retrieve_gear(activity["gear_id"])
    gear_row = [gear["name"], (gear["distance"]/1600).round(2)]
  else
    gear_row = "no gear listed"
  end
  gear_row
end

def get_notes(activity)
  desc = @client.retrieve_an_activity(activity["id"])["description"]
  if desc
    notes = desc
  else
    notes = "no notes for this run"
  end
  notes
end




page_num = 1
rows = []

runs = (@client.list_athlete_activities(page: page_num, per_page: 200).select { |run| run["type"] == "Run" }) rescue nil

# FIXME This is stuck in infinite loop
while runs && !runs.empty?
  format_data(rows, runs)
  byebug
  page_num+= 1
end

csv_options = {
  write_headers: true,
  headers: [
    "name", "miles", "duration", "pace", "date",
    "time", "shoe", "shoe-miles", "notes"
  ]
}

CSV.open('test.csv', 'w', csv_options) do |csv_object|
  rows.each do |row|
    csv_object << row
  end
end
