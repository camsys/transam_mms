class MaintenanceEventsController < AssetAwareController 

  add_breadcrumb "Home", :root_path
  
  before_filter :set_maintenance_event, :only => [:show, :edit, :update, :destroy]  
  before_filter :reformat_date_field,   :only => [:create, :update]
  
  INDEX_KEY_LIST_VAR    = "maintenance_event_key_list_cache_var"
  
  # GET /maintenance_events
  # GET /maintenance_events.json
  def index

    add_breadcrumb @asset.asset_tag, inventory_path(@asset)
    add_breadcrumb "Maintenance History", inventory_maintenance_events_path(@asset)

  end

  # GET /maintenance_events/1
  # GET /maintenance_events/1.json
  def show
    
    add_breadcrumb @asset.asset_tag, inventory_path(@asset)
    add_breadcrumb "Maintenance History", inventory_maintenance_events_path(@asset)
    add_breadcrumb "Service on #{@maintenance_event.event_date}"
        
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @maintenance_event }
    end

  end
  
  # GET /maintenance_events/new
  def new

    add_breadcrumb @asset.asset_tag, inventory_path(@asset)
    add_breadcrumb "Maintenance History", inventory_maintenance_events_path(@asset)
    add_breadcrumb "Record Service"

    @maintenance_event = MaintenanceEvent.new

    respond_to do |format|
      format.html 
      format.json { render :json => @maintenance_event }
    end

  end

  # GET /maintenance_events/1/edit
  def edit
    
    add_breadcrumb @asset.asset_tag, inventory_path(@asset)
    add_breadcrumb "Maintenance History", inventory_maintenance_events_path(@asset)
    add_breadcrumb "Service on #{@maintenance_event.date}"
    add_breadcrumb "Update"
     
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @maintenance_event }
    end

  end

  # POST /maintenance_events
  # POST /maintenance_events.json
  def create
    
    add_breadcrumb @asset.asset_tag, inventory_path(@asset)
    add_breadcrumb "Maintenance History", inventory_maintenance_events_path(@asset)
    add_breadcrumb "Record Service"

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

  # PATCH/PUT /maintenance_events/1
  # PATCH/PUT /maintenance_events/1.json
  def update

    add_breadcrumb @asset.asset_tag, inventory_path(@asset)
    add_breadcrumb "Maintenance History", inventory_maintenance_events_path(@asset)
    add_breadcrumb "Service on #{@maintenance_event.date}"
    add_breadcrumb "Update"

    respond_to do |format|
      if @maintenance_event.update(form_params)
        notify_user(:notice, "The service record was successfully updated.")
        format.html { redirect_to inventory_maintenance_event_url(@asset, @maintenance_event) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @maintenance_event.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /maintenance_events/1
  # DELETE /maintenance_events/1.json
  def destroy
    @maintenance_event.destroy
    notify_user(:notice, "The service record  was successfully removed.")
    respond_to do |format|
      format.html { redirect_to inventory_maintenance_events_url(@asset) }
      format.json { head :no_content }
    end
  end

  #------------------------------------------------------------------------------
  #
  # Private Methods
  #
  #------------------------------------------------------------------------------
  private

  def set_maintenance_event
    @maintenance_event = @asset.maintenance_events.find_by(:object_key => params[:id])
  end

  def reformat_date_field
    date_str = params[:maintenance_event][:event_date]
    form_date = Date.strptime(date_str, '%m-%d-%Y')
    params[:maintenance_event][:event_date] = form_date.strftime('%Y-%m-%d')
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def form_params
    params.require(:maintenance_event).permit(MaintenanceEvent.allowable_params)
  end
    
end
