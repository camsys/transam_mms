class MaintenanceForecastsController < OrganizationAwareController 

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Service Schedule", :maintenance_forecasts_path
    
  INDEX_KEY_LIST_VAR    = "maintenance_forecast_key_list_cache_var"
  
  # GET /maintenance_forecasts
  # GET /maintenance_forecasts.json
  def index
    
    start_month = Date.today.beginning_of_month
    @months = []
    @months << start_month
    (1..5).each do |i|
      @months << start_month + i.months 
    end
    
    service = MaintenanceSchedulingService.new
    @service_schedules = service.services_due(@organization_list)
    
    respond_to do |format|
      format.html # index.html.erb
    end
    
  end

end
