class TrailheadsController < ApplicationController
  before_action :set_trailhead, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:email]

  def email
    Delayed::Job.enqueue ProcessEmail.new(params)
    render plain: "DONE"
  end

  # GET /trailheads
  # GET /trailheads.json
  def index
    @trailheads = Trailhead.latest
    if id = params[:user_id]
      if(@user = User.find(id))
        @trailheads = @user.trailheads.latest
      else
        @trailheads = Trailhead.none
      end
    elsif email = params[:user_email]
      if @user = User.find_by_email(email)
        @trailheads = @user.trailheads.latest
      else
        @trailheads = Trailhead.none
      end
    end
    respond_to do |format|
      format.html{}
      format.json do
        render json: @trailheads.to_geojson
      end
      format.geojson do
        render json: @trailheads.to_geojson
      end
      format.js do
        render json: @trailheads.to_geojson
      end
    end
  end

  def map
    @trailheads = Trailhead.latest
    if @user = params[:user_id]
      @user = User.find(params[:user_id])
      @trailheads = @user.trailheads.latest
    end
  end

  def wall
  end

  # GET /trailheads/1
  # GET /trailheads/1.json
  def show
    respond_to do |format|
      format.html{}
      format.json{}
      format.geojson do
        render json: @trailhead.to_geojson
      end
      format.js do
        render json: @trailhead.to_geojson
      end
    end
  end

  # GET /trailheads/new
  def new
    lat = request.location.latitude || 0
    lon = request.location.longitude || 0
    @trailhead = Trailhead.new(latitude:lat, longitude:lon)
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
        begin
          if Rails.env.production?
            photo_path = open(@trailhead.photo.url).path
          else
            photo_path = @trailhead.photo.path
          end
          @exif = @trailhead.exifXtractr(photo_path)
          puts @exif.gps
          @trailhead.update_attributes(
            latitude:@exif.gps.try(:latitude)||@trailhead.latitude||0.0,
            longitude:@exif.gps.try(:longitude)||@trailhead.longitude||0.0,
            taken_at:@exif.try(:date_time),
            altitude:@exif.gps.try(:altitude))
        rescue Exception => e
          Rails.logger.error(e)
        end

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
        @updated = true
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
      params.require(:trailhead).permit(:name, :latitude, :longitude, :photo, :parking,
        :drinking_water, :restrooms, :kiosk, :user_id, :remove_photo, :social, :gated)
    end
end
