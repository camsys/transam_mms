class MaintenanceSchedulesController < OrganizationAwareController
   
  before_filter :set_view_vars,  :only =>    [:index]
   
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Maintenance Schedules", :maintenance_schedules_path
    
  INDEX_KEY_LIST_VAR    = "maintenance_schedule_key_list_cache_var"
        
  # Controller actions that can be invoked from the view
  REPLACE_ACTION              = '1'
  REHABILITATE_ACTION         = '2'
  REMOVE_FROM_SERVICE_ACTION  = '3'
  RESET_ACTION                = '4'
    
  ACTIONS = [
    ["Replace", REPLACE_ACTION],
    ["Rehabilitate", REHABILITATE_ACTION],
    ["Remove from service (no replacement)", REMOVE_FROM_SERVICE_ACTION],
    ["Reset to policy", RESET_ACTION]
  ]
    
  YES = '1'
  NO = '0'
  
  BOOLEAN_SELECT = [
    ['Yes', YES],
    ['No', NO]
  ]
          
  # Returns the list of assets that are scheduled for replacement/rehabilitation in the given
  # fiscal years.
  def index

    # Get the asset scheduled for each week   
    @week1_assets = get_assets(@week_1)        
    @week2_assets = get_assets(@week_2)        
    @week3_assets = get_assets(@week_3)        
    @week4_assets = get_assets(@week_4)        
   
  end
    
  protected
  
  # Sets the view variables that control the filters. called before each action is invoked
  def set_view_vars

    @org_id = params[:org_id].blank? ? nil : params[:org_id].to_i
    
    # This is the first week that the user can view
    first_week = Date.today.strftime("%W").to_i
    
    last_week = first_week + 52
    # This is an array of years that the user can plan for
    weeks = (first_week..last_week).to_a
    
    # Set the view up. Start week is the first week in the view
    @start_week = params[:start_week].blank? ? first_week : params[:start_week].to_i
    @week1 = @start_week
    @week2 = @start_week + 1
    @week3 = @start_week + 2
    @week4 = @start_week + 3
    
    # Add ability to page a whole year
    @total_rows = 52
    # get the index of the start week in the array      
    current_index = weeks.index(@start_week)
    @row_number = current_index + 1
    if current_index == 0
      @prev_record_path = "#"
    else
      @prev_record_path = maintenance_schedules__path(:start_week => @start_week - 1)
    end
    if current_index == (@total_rows - 1)
      @next_record_path = "#"
    else
      @next_record_path = scheduler_index_path(:start_week => @start_week + 1)
    end
    @row_pager_remote = true
     
  end
  
  def get_assets(year)
    
    # check to see if there is a filter on the organization
    org = @org_id.blank? ? @organization.id : @org_id
    projects = CapitalProject.where('organization_id = ? AND fy_year = ?', org, year)
    
    alis = ActivityLineItem.where(:capital_project_id => projects)
    alis
  end
  
  private
  
end
