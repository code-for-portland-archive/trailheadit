class TrailheadsController < ApplicationController
  before_action :set_trailhead, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:email]

  def email
    
    # process various message parameters:
    @sender  = params['sender']
    @subject = params['subject']

    # get the "stripped" body of the message, i.e. without
    # the quoted part
    @actual_body = params["stripped-text"]

    attachments = JSON.parse params['attachments']
    puts "ATTACHMENTS"
    if attachments.present?
      puts attachments.count
      attachments.each do |a|
        puts "ATTACHMENT #{a}"
        
        # stream = params["attachment-#{i+1}"]
        # filename = stream.original_filename
        # data = stream.read() 
        # puts data.length     

        api_key = ENV['MAILGUN_API_KEY']
        url = a['url']
        # url.gsub!('https://',"https://api:#{api_key}@")
        test = open(url,:http_basic_authentication=>['api','key-7vasqtc4mg9w645w5w86za-3kay2co66'])        
        @trailhead = Trailhead.create(name:@subject, email:@sender, photo:File.open(test.path))                  
        @exif = @trailhead.exifXtractr(test.path)
                
        @trailhead.update_attributes(
          latitude:@exif.gps.latitude||@trailhead.latitude,
          longitude:@exif.gps.longitude||@trailhead.longitude,
          taken_at:@exif.date_time,
          altitude:@exif.gps.altitude,
          email_properties:params)
        
        # find or create the user
        if User.exists?(email: @sender)
          puts "USER FOUND"
          @user = User.find_by(email: @sender)
          @user.trailheads << @trailhead
        else
          puts "USER NOT FOUND"
          @user = User.create(email: @sender)          
          @user.trailheads << @trailhead
          UserMailer.welcome_email(@user).deliver
        end
      end
      # now data needs to be parsed for lat lng and then attached to the carrier wave uploader
    end     
    puts "END OF EMAIL"
    render plain: "DONE"
  end

  # GET /trailheads
  # GET /trailheads.json
  def index
    @trailheads = Trailhead.order('id desc').all
  end

  # GET /trailheads/1
  # GET /trailheads/1.json
  def show
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
      params.require(:trailhead).permit(:name, :latitude, :longitude, :photo, :parking, :drinking_water, :restrooms, :kiosk)
    end
end
