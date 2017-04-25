require 'csv'

class Harrier
  def initialize(token)
    @client = Strava::Api::V3::Client.new(access_token: token)
    @page_num = 1
    @rows = []
    @gear_record = {}
  end


  # def test
  #   File.open('thing.txt', "w") do |file|
  #     file.puts("sup dude")
  #   end
  # end

  # TODO Error handling (rate limiting)
  def gen_csv
    runs = (@client.list_athlete_activities(page: @page_num, per_page: 200).select { |activity| activity["type"] == "Run" })
    while runs && !runs.empty?
      # begin
      format_data(runs)
      # rescue
      @page_num += 1
      runs = (@client.list_athlete_activities(page: @page_num, per_page: 200).select { |activity| activity["type"] == "Run" })
    end

    csv_options = {
      write_headers: true,
      headers: [
        "name", "miles", "duration", "pace", "date",
        "time", "shoe", "shoe-miles", "notes"
      ]
    }

    CSV.open('../../logs.csv', 'w', csv_options) do |csv_object|
      @rows.each do |row|
        csv_object << row end
    end
  end


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

  def get_notes(activity)
    desc = @client.retrieve_an_activity(activity["id"])["description"]
    if desc
      desc
    else
      desc = "no notes for this run"
    end
  end

  def format_data(runs)
    runs.map do |run|
      name = run["name"]
      miles = (run["distance"]/1600).round(2)
      minutes_duration = (run["moving_time"]/60).round(2)
      mile_pace = (1/(run["average_speed"]/1600 * 60)).round(2)
      date = DateTime.parse(run["start_date_local"]).strftime("%m/%d/%Y")
      time = DateTime.parse(run["start_date_local"]).strftime("%T")

      gear_row = get_gear(run)     # ----> TODO parallelize these if possible
      description = get_notes(run) # ____/

      row = [name, miles, minutes_duration, mile_pace, date, time, gear_row, description].flatten
      @rows << row
    end
  end
end
