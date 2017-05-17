require 'csv'

class Harrier
  def initialize(token)
    @client = Strava::Api::V3::Client.new(access_token: token)
    @ids = []
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

    CSV.open('../../tmp/logs.csv', 'w', csv_options) do |csv_object|
      @rows.each do |row|
        csv_object << row
      end
    end
  end

  def get_activity_ids
    while true
      ids = @client.list_athlete_activities(page: @page_num, per_page: 200)
        .select { |activity| activity["type"] == "Run" }
        .map { |activity| activity["id"] }
      @ids << ids
      @page_num += 1
      break if ids.length < 200
    end
  end


	def get_activity_data
		@ids.flatten.each do |id|
			begin
				activity = @client.retrieve_an_activity(id)
				name = activity["name"]
				miles = (activity["distance"]/1600).round(2)
				minutes_duration = (activity["moving_time"]/60).round(2)
				mile_pace = (1/(activity["average_speed"]/1600 * 60)).round(2)
				date = DateTime.parse(activity["start_date_local"]).strftime("%m/%d/%Y")
				time = DateTime.parse(activity["start_date_local"]).strftime("%T")
        if activity["gear"]
          gear_name = activity["gear"]["name"]
          gear_distance = activity["gear"]["distance"]/1600.round(2)
        else
          gear_name = "n/a"
          gear_distance = "n/a"
        end
				description = activity["description"]
				row = [name, miles, minutes_duration, mile_pace, date, time, gear_name, gear_distance, description]
			rescue Strava::Api::V3::ClientError => e
				if e.message.include?("rate limit")
          puts "sleeping for 15 minutes due to rate limits"
					sleep 900
					retry
				else
					row = "Misc API error prevented successful export of this activity"
				end
			end
			@rows << row
		end
	end

end
