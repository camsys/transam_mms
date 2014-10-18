class MaintenanceSchedulesController < OrganizationAwareController 

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Maintenance Schedules", :maintenance_schedules_path
  
  before_action :set_schedule,            :only => [:show, :edit, :update, :destroy]
  
  INDEX_KEY_LIST_VAR    = "maintenance_schedule_key_list_cache_var"
  
  # GET /maintenance_schedules
  # GET /maintenance_schedules.json
  def index
    
     # Start to set up the query
    conditions  = []
    values      = []

    @asset_subtype_id = params[:asset_subtype_id]
    unless @asset_subtype_id.blank?
      @asset_subtype_id = @asset_subtype_id.to_i
      conditions << 'asset_subtype_id = ?'
      values << @asset_subtype_id
    end
        
    #puts conditions.inspect
    #puts values.inspect
    @schedules = MaintenanceSchedule.where(conditions.join(' AND '), *values)

    # cache the set of object keys in case we need them later
    cache_list(@schedules, INDEX_KEY_LIST_VAR)

    if @asset_subtype_id.blank?
      add_breadcrumb "All"
    else 
      add_breadcrumb AssetSubtype.find(@asset_subtype_id)
    end
          
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @schedules }
    end
    
  end

  # GET /maintenance_schedules/1
  # GET /maintenance_schedules/1.json
  def show
    
    add_breadcrumb @schedule
        
    # get the @prev_record_path and @next_record_path view vars
    get_next_and_prev_object_keys(@schedule, INDEX_KEY_LIST_VAR)
    @prev_record_path = @prev_record_key.nil? ? "#" : maintenance_schedule_path(@prev_record_key)
    @next_record_path = @next_record_key.nil? ? "#" : maintenance_schedule_path(@next_record_key)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @schedule }
    end

  end
  
  # GET /maintenance_schedules/new
  def new

    add_breadcrumb "New Maintenance Schedule", new_maintenance_schedule_path

    @schedule = MaintenanceSchedule.new

  end

  # GET /maintenance_schedules/1/edit
  def edit
    
    add_breadcrumb @schedule, maintenance_schedule_path(@schedule)
    add_breadcrumb "Modify"

  end

  # POST /maintenance_schedules
  # POST /maintenance_schedules.json
  def create
    
    add_breadcrumb "New Maintenance Schedule", new_maintenance_schedule_path

    @schedule = MaintenanceSchedule.new(form_params)
    @schedule.organization = @organization
    
    respond_to do |format|
      if @schedule.save        
        notify_user(:notice, "The Maintenance Schedule was successfully saved.")
        format.html { redirect_to maintenance_schedule_url(@schedule) }
        format.json { render action: 'show', status: :created, location: @schedule }
      else
        format.html { render action: 'new' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /maintenance_schedules/1
  # PATCH/PUT /maintenance_schedules/1.json
  def update

    add_breadcrumb @schedule, maintenance_schedule_path(@schedule)
    add_breadcrumb "Modify"

    respond_to do |format|
      if @schedule.update(form_params)
        notify_user(:notice, "The Maintenance Schedule was successfully updated.")
        format.html { redirect_to maintenance_schedule_url(@schedule) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /maintenance_schedules/1
  # DELETE /maintenance_schedules/1.json
  def destroy
    @schedule.destroy
    notify_user(:notice, "The Maintenance Schedule was successfully removed.")
    respond_to do |format|
      format.html { redirect_to maintenance_schedules_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      @schedule = MaintenanceSchedule.find_by_object_key(params[:id])
      if @schedule.nil?
        notify_user(:alert, "Record not found.")
        redirect_to maintenance_schedules_url
        return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def form_params
      params.require(:maintenance_schedule).permit(MaintenanceSchedule.allowable_params)
    end


end
