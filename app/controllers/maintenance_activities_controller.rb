class MaintenanceActivitiesController < OrganizationAwareController
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Maintenance Schedules", :maintenance_schedules_path
  
  before_action :set_maintenance_schedule
  before_action :set_maintenance_activity, only: [:show, :edit, :update, :destroy]

  # GET /maintenance_activities/new
  def new
    
    add_breadcrumb @schedule, maintenance_schedule_path(@schedule)
    add_breadcrumb "New service task"
        
    @schedule = MaintenanceSchedule.find_by_object_key(params[:maintenance_schedule_id])
    @maintenance_activity = MaintenanceActivity.new
  end

  # GET /maintenance_activities/1/edit
  def edit
    add_breadcrumb @schedule, maintenance_schedule_path(@schedule)
    add_breadcrumb "#{@maintenance_activity} Update"
  end

  # POST /maintenance_activities
  def create

    add_breadcrumb @schedule, maintenance_schedule_path(@schedule)
    add_breadcrumb "New service task"
    
    @maintenance_activity = MaintenanceActivity.new(maintenance_activity_params)
    @maintenance_activity.maintenance_schedule = @schedule
    
    if @maintenance_activity.save
      notify_user(:notice, "Maintenance activity was successfully created.")
      # Determine which button was clicked and redirect to the correct URL
      if params[:commit].include? "another"
        redirect_to new_maintenance_schedule_maintenance_activity_path @schedule
      else
        redirect_to maintenance_schedule_url @schedule
      end
    else
      render :new
    end
  end

  # PATCH/PUT /maintenance_activities/1
  def update
    add_breadcrumb @schedule, maintenance_schedule_path(@schedule)
    add_breadcrumb "#{@maintenance_activity} Update"
    
    if @maintenance_activity.update(maintenance_activity_params)
      notify_user(:notice, "Maintenance activity was successfully updated.")
      redirect_to maintenance_schedule_url @schedule
    else
      render :edit
    end
  end

  # DELETE /maintenance_activities/1
  def destroy
    @maintenance_activity.destroy
    notify_user(:notice, "Maintenance activity was successfully removed.")
    redirect_to maintenance_schedule_url @maintenance_schedule
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_schedule
      @schedule = MaintenanceSchedule.find_by_object_key(params[:maintenance_schedule_id])
    end

    def set_maintenance_activity
      @maintenance_activity = @schedule.maintenance_activities.find_by_object_key(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def maintenance_activity_params
      params.require(:maintenance_activity).permit(MaintenanceActivity.allowable_params)
    end
end
