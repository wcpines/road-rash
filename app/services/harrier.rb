require 'csv'

class Harrier
  def initialize(token)
    @client = Strava::Api::V3::Client.new(access_token: token)
    @gear_record = {}
    @page_num = 1
    @rows = []
  end

  def gen_csv
    csv_options = {
      write_headers: true,
      headers: [
        "name", "miles", "duration", "pace", "date",
        "time", "shoe", "shoe-miles", "description"
      ]
    }

    CSV.open('../../logs.csv', 'w', csv_options) do |csv_object|
      @rows.each do |row|
        csv_object << row
      end
    end
  end

	def get_activities
		2.times do
			activities = (@client.list_athlete_activities(page: @page_num, per_page: 200).select { |activity| activity["type"] == "Run" })
			format_data(activities)
			@page_num += 1
		end
	end

  def format_data(activities)
    activities.map do |activity|
      name = activity["name"]
      miles = (activity["distance"]/1600).round(2)
      minutes_duration = (activity["moving_time"]/60).round(2)
      mile_pace = (1/(activity["average_speed"]/1600 * 60)).round(2)
      date = DateTime.parse(activity["start_date_local"]).strftime("%m/%d/%Y")
      time = DateTime.parse(activity["start_date_local"]).strftime("%T")

      gear = get_gear(activity)
      description = get_description(activity)

      row = [name, miles, minutes_duration, mile_pace, date, time, gear, description].flatten
      @rows << row
    end
  end


  # NOTE: Only call API 1x per unique gear item,
  # otherise append latest info to a given activity
  def get_gear(activity)
    if @gear_record[activity["gear_id"]]
      gear_row = @gear_record[activity["gear_id"]]
    elsif activity["gear_id"]
      gear = @client.retrieve_gear(activity["gear_id"])
      gear_row = [gear["name"], (gear["distance"]/1600).round(2)]
      @gear_record[activity["gear_id"]] = gear_row
    else
      gear_row = ["no  gear listed", "n/a"]
    end
  end


  def get_description(activity)
    desc = @client.retrieve_an_activity(activity["id"])["description"]
    if desc
      desc
    else
      desc = "no description for this activity"
    end
  end
end
