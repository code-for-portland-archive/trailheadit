class TrailheadsController < ApplicationController
  before_action :set_trailhead, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, only: [:email]

  def email
    Delayed::Job.enqueue ProcessEmail.new(params)    
  end

  # GET /trailheads
  # GET /trailheads.json
  def index
    @trailheads = Trailhead.latest
    if @user = params[:user_id]
      @user = User.find(params[:user_id])
      @trailheads = @user.trailheads.latest
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
        begin
          @exif = @trailhead.exifXtractr(@trailhead.photo.path)
          @trailhead.update_attributes(
            latitude:@exif.gps.try(:latitude)||@trailhead.latitude,
            longitude:@exif.gps.try(:longitude)||@trailhead.longitude,
            taken_at:@exif.try(:date_time),
            altitude:@exif.gps.try(:altitude))
        rescue
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
