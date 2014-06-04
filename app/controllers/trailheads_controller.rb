class TrailheadsController < ApplicationController
  before_action :set_trailhead, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:email]

  def email
    
    # process various message parameters:
    mail_from = Mail::Address.new(params['from'] || params['sender'])
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

    attachments = JSON.parse params['attachments']    
    if attachments.present?
      Rails.logger.info attachments.count
      attachments.each do |a|
        Rails.logger.info "ATTACHMENT #{a}"
        
        # stream = params["attachment-#{i+1}"]
        # filename = stream.original_filename
        # data = stream.read() 
        # puts data.length     

        api_key = ENV['MAILGUN_API_KEY']
        url = a['url']
        # url.gsub!('https://',"https://api:#{api_key}@")
        test = open(url,:http_basic_authentication=>['api',ENV['MAILGUN_API_KEY']])        

        @trailhead = Trailhead.create(name:@subject, email:@sender, photo:File.open(test.path))                  
        @user.trailheads << @trailhead
        @trailheads << @trailhead
        @exif = @trailhead.exifXtractr(test.path)
                
        @trailhead.update_attributes(
          latitude:@exif.gps.latitude||@trailhead.latitude,
          longitude:@exif.gps.longitude||@trailhead.longitude,
          taken_at:@exif.date_time,
          altitude:@exif.gps.altitude,
          email_properties:params,
          exif_properties:@exif)
        
      end
    end     

    if Rails.env.production?
      UserMailer.welcome_email(@user,@trailheads).deliver
    end
    
    render plain: "DONE"
  rescue Exception => e
    Rails.logger.error "ERROR"
    Rails.logger.error e.message
    e.backtrace.each { |line| Rails.logger.error line }
    render plain: "ERROR"
  end

  # GET /trailheads
  # GET /trailheads.json
  def index
    @trailheads = Trailhead.order('id desc').all
    if @user = params[:user_id]
      @user = User.find(params[:user_id])
      @trailheads = @user.trailheads
    end
    respond_to do |format|
      format.html{}        
      format.json do
        render json: @trailheads.to_geojson
      end
      format.js do
        render json: @trailheads.to_geojson
      end
    end
  end

  # GET /trailheads/1
  # GET /trailheads/1.json
  def show
    respond_to do |format|
      format.html{}        
      format.js do
        render json: @trailhead.to_geojson
      end
    end
  end

  # GET /trailheads/new
  def new
    @trailhead = Trailhead.new
  end

  # GET /trailheads/1/edit
  def edit
    unless @trailhead.viewed_at
      @trailhead.update_attributes(:viewed_at => Time.now)  
    end
  end

  # POST /trailheads
  # POST /trailheads.json
  def create

    @trailhead = Trailhead.new(trailhead_params)

    respond_to do |format|
      if @trailhead.save
        @exif = @trailhead.exifXtractr(@trailhead.photo.path)
        @trailhead.update_attributes(
          latitude:@exif.gps.latitude||@trailhead.latitude,
          longitude:@exif.gps.longitude||@trailhead.longitude,
          taken_at:@exif.date_time,
          altitude:@exif.gps.altitude)


        format.html { redirect_to @trailhead, notice: 'Trailhead was successfully created.' }
        format.json { render :show, status: :created, location: @trailhead }
      else
        format.html { render :new }
        format.json { render json: @trailhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trailheads/1
  # PATCH/PUT /trailheads/1.json
  def update
    respond_to do |format|
      if @trailhead.update(trailhead_params)
        format.html { redirect_to @trailhead, notice: 'Trailhead was successfully updated.' }
        format.json { render :show, status: :ok, location: @trailhead }
      else
        format.html { render :edit }
        format.json { render json: @trailhead.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trailheads/1
  # DELETE /trailheads/1.json
  def destroy
    @trailhead.destroy
    respond_to do |format|
      format.html { redirect_to trailheads_url, notice: 'Trailhead was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trailhead
      @trailhead = Trailhead.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trailhead_params
      params.require(:trailhead).permit(:name, :latitude, :longitude, :photo, :parking, :drinking_water, :restrooms, :kiosk, :user_id)
    end
end
