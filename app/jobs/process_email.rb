ProcessEmail = Struct.new(:params) do
  def perform
    # process various message parameters:
    mail_from = Mail::Address.new(params['from'] || params['sender'])
    mail_to = Mail::Address.new(params['To'].presence || params['recipient'].presence)
    @sender  = mail_from.address
    @name = mail_from.name
    @subject = params['subject']

    # get the "stripped" body of the message, i.e. without
    # the quoted part
    @actual_body = params["stripped-text"]

    # find or create the user
    if User.exists?(email: @sender)
      Rails.logger.info "USER FOUND"
      @user = User.find_by(email: @sender)
    else
      Rails.logger.info "USER NOT FOUND"
      @user = User.create(email: @sender, name: @name)
    end

    @trailheads = []
    @trailheads_nogps = []

    attachments = JSON.parse params['attachments']
    if attachments.present?
      Rails.logger.info attachments.count
      attachments.each do |a|
        Rails.logger.info "ATTACHMENT #{a}"

        api_key = ENV['MAILGUN_API_KEY']
        url = a['url']
        # url.gsub!('https://',"https://api:#{api_key}@")
        test = open(url,:http_basic_authentication=>['api',ENV['MAILGUN_API_KEY']])
        social = nil
        mail_to = mail_to.to_s.strip
        Rails.logger.info("mail_to = #{mail_to}")
        if(mail_to.starts_with? "social@")
          Rails.logger.info("SOCIAL!")
          social = true
        end
        @trailhead = Trailhead.new(name:@subject,
          email:@sender,
          photo:File.open(test.path),
          social:social,
          email_properties:params)
        @user.trailheads << @trailhead
        begin
          @exif = @trailhead.exifXtractr(test.path)

          @trailhead.update_attributes(
            latitude:@exif.gps.try(:latitude)||@trailhead.latitude||0.0,
            longitude:@exif.gps.try(:longitude)||@trailhead.longitude||0.0,
            taken_at:@exif.try(:date_time),
            altitude:@exif.gps.try(:altitude),
            exif_properties:@exif.to_json)
          if @trailhead.latitude == 0.0
            @trailheads_nogps << @trailhead
          else
            @trailheads << @trailhead
          end
          if Rails.env.production?
            open("http://www.outerspatial.com/trailheads/#{@trailhead.id}/traileditor")
          end
        rescue
        end
      end
    end

    if Rails.env.production?
      unless @trailheads.blank?
        UserMailer.welcome_email(@user, @trailheads).deliver
      end
      unless @trailheads_nogps.blank?
        UserMailer.welcome_email_nogps(@user, @trailheads_nogps).deliver
      end
    end

  rescue Exception => e
    Rails.logger.error "ERROR"
    Rails.logger.error e.message
    e.backtrace.each { |line| Rails.logger.error line }
  end

  def process_trailhead
  end

  def process_water
  end

end