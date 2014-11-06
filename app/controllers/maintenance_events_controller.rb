class MaintenanceEventsController < AssetAwareController 

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Maintenance History", :maintenance_events_path
  
  before_filter :get_maintenace_event,  :only => [:show, :edit, :update, :destroy]  
  before_filter :check_for_cancel,      :only => [:create, :update]
  before_filter :reformat_date_field,   :only => [:create, :update]
  
  INDEX_KEY_LIST_VAR    = "maintenance_event_key_list_cache_var"
  
  # GET /maintenance_events
  # GET /maintenance_events.json
  def index
    
    
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

    @maintenance_event = MaintenanceEvent.new

    add_new_show_create_breadcrumbs

    respond_to do |format|
      format.html 
      format.json { render :json => @maintenance_event }
    end

  end

  # GET /maintenance_schedules/1/edit
  def edit
    
    add_edit_update_breadcrumbs
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @maintenance_event }
    end

  end

  # POST /maintenance_schedules
  # POST /maintenance_schedules.json
  def create
    
    add_new_show_create_breadcrumbs

    @maintenance_event = MaintenanceEvent.new(form_params)
    @maintenance_event.asset = @asset
    @maintenance_event.completed_by = current_user
    
    respond_to do |format|
      if @maintenance_event.save
        # See if a comment was passed
        if form_params[:comment]
          @maintenance_event.comments << Comment.new({:comment => form_params[:comment], :creator => current_user})
        end
        notify_user(:notice, "Maintenance was successfully recorded.")   
                
        format.html { redirect_to inventory_url(@asset) }
        format.json { render :json => @maintenance_event, :status => :created, :location => @maintenance_event }
      else
        Rails.logger.debug @maintenance_event.errors.inspect
        format.html { render :action => "new" }
        format.json { render :json => @maintenance_event.errors, :status => :unprocessable_entity }
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

  #------------------------------------------------------------------------------
  #
  # Private Methods
  #
  #------------------------------------------------------------------------------
  private

  def reformat_date_field
    date_str = params[:maintenance_event][:event_date]
    form_date = Date.strptime(date_str, '%m-%d-%Y')
    params[:maintenance_event][:event_date] = form_date.strftime('%Y-%m-%d')
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def form_params
    params.require(:maintenance_event).permit(MaintenanceEvent.allowable_params)
  end

  def add_new_show_create_breadcrumbs
    #add_asset_breadcrumbs
    #add_breadcrumb @maintenance_event
  end

  def add_edit_update_breadcrumbs
    add_asset_breadcrumbs
    add_breadcrumb @maintenance_event, inventory_maintenance_event_path(@asset, @maintenance_event)
    add_breadcrumb "Update"
  end

  def check_for_cancel
    # go back to the asset view
    unless params[:cancel].blank?
      redirect_to(inventory_url(@asset))
    end    
  end
    
end
