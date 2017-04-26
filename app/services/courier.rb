class Courier
  @queue = :courier_queue

  # resque class method
  def self.test(email_address, name, token)
    puts "hello #{name} at #{email_address}"
  end

  def self.perform(email_address, name, token)
    harrier = Harrier.new(token)
    harrier.gen_csv

    Mail.defaults do
      delivery_method(:smtp, {
        address: "smtp.gmail.com",
        port: 587,
        user_name: 'roadrash.csv.exporter@gmail.com',
        password: ENV['GMAIL_PASS'],
        authentication: :plain,
        enable_starttls_auto: true
      })
    end


    mail = Mail.new do
      from('roadrash.csv.exporter@gmail.com')
      to("#{email_address}")
      subject("#{name} Strava Logs")
      body("Please find your runnings logs attached.  Questions or concerns can
           be sent to roadrash.csv.exporter@gmail.com"
          )
      add_file("../../logs.csv")
    end

    mail.deliver!
  end
end
