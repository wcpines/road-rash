class Courier
  @queue = :courier_queue

  def self.perform(email_address, name, token)
    harrier = Harrier.new(token)
    harrier.get_activity_ids
    harrier.get_activity_data
    harrier.gen_csv

    Mail.defaults do
      delivery_method(:smtp, {
        address: "smtp.gmail.com",
        port: 587,
        user_name: "roadrash.csv.exporter@gmail.com",
        password: ENV["GMAIL_PASS"],
        authentication: :plain,
        enable_starttls_auto: true
      })
    end

    mail = Mail.new do
      from("roadrash.csv.exporter@gmail.com")
      to("#{email_address}")
      subject("#{name} Strava Logs")
      body("Please find your runnings logs attached.  Questions or concerns can
         be sent to roadrash.csv.exporter@gmail.com"
          )
      add_file("../../tmp/logs.csv")
    end

    mail.deliver!
  end
end
