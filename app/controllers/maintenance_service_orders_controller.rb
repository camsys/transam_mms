class MaintenanceServiceOrdersController < OrganizationAwareController

  add_breadcrumb "Home", :root_path
  add_breadcrumb "Work Orders", :maintenance_service_orders_path

  before_action :set_maintenance_service_order, :only => [:show, :edit, :update, :destroy, :fire_workflow_event, :complete, :update_service_status]
  before_action :set_asset,                     :only => [:show, :edit, :update, :complete]
  before_action :reformat_date_field,           :only => [:create, :update]

  INDEX_KEY_LIST_VAR    = "maintenance_service_order_key_list_cache_var"

  def fire_workflow_event

    # Check that this is a valid event name for the state machines
    if @maintenance_service_order.class.event_names.include? params[:event]
      event_name = params[:event]
      if @maintenance_service_order.fire_state_event(event_name)
        event = WorkflowEvent.new
        event.creator = current_user
        event.accountable = @maintenance_service_order
        event.event_type = event_name
        event.save
        notify_user(:notice, "Work order #{@maintenance_service_order.workorder_number} is now #{@maintenance_service_order.state.humanize}.")
      else
        notify_user(:alert, "Could not #{event_name.humanize} work order #{@maintenance_service_order.project_number}")
      end
    else
      notify_user(:alert, "#{params[:event_name]} is not a valid event for a Servivce Workorder")
    end

    redirect_back(fallback_location: root_path)

  end

  def index
    order_params = {organization_id: @organization_list}
    order_params[Rails.application.config.asset_base_class_name.foreign_key.to_sym] = params[:asset_id] if params[:asset_id]
    @maintenance_service_orders = MaintenanceServiceOrder.unscoped.select('maintenance_service_orders.*, sum_events').joins('INNER JOIN (SELECT maintenance_service_order_id, COUNT(maintenance_events.id) AS sum_events FROM maintenance_events GROUP BY maintenance_service_order_id) as sum_events_table ON sum_events_table.maintenance_service_order_id = maintenance_service_orders.id').where(order_params).includes(:maintenance_provider, Rails.application.config.asset_base_class_name.underscore.to_sym)
    if params[:sort] && params[:order]
      sort_clause = "#{params[:sort]} #{params[:order]}"
    else
      sort_clause = "maintenance_service_orders.order_date DESC, maintenance_service_orders.created_at DESC"
    end

    # cache the set of object keys in case we need them later
    cache_list(@maintenance_service_orders,  INDEX_KEY_LIST_VAR)

    respond_to do |format|
      format.html
      format.json {
        render :json => {
            :total => @maintenance_service_orders.length,
            :rows =>  @maintenance_service_orders.order(sort_clause).limit(params[:limit]).offset(params[:offset]).collect{ |p| p.as_json.merge!(
                {
                    maintenance_provider: p.maintenance_provider.try(:name),
                    asset: p.asset.to_s,
                    maintenance_activity_type: p.maintenance_events.first.try(:maintenance_activity_type).try(:name),
                    priority_type: p.priority_type.to_s,
                    due_month: p.maintenance_events.first.try(:due_date).try(:strftime,'%B %Y'),
                    completed_date: p.workflow_events.where(event_type: ['complete', 'mark_complete']).last.try(:created_at)

                })}
        }
      }
    end

  end

  def show

    add_breadcrumb @maintenance_service_order

    # get the @prev_record_path and @next_record_path view vars
    get_next_and_prev_object_keys(@maintenance_service_order, INDEX_KEY_LIST_VAR)
    @prev_record_path = @prev_record_key.nil? ? "#" : maintenance_service_order_path(@prev_record_key)
    @next_record_path = @next_record_key.nil? ? "#" : maintenance_service_order_path(@next_record_key)

  end
  # GET /maintenance_service_order/new
  def new

    add_breadcrumb "New"

    @maintenance_service_order = MaintenanceServiceOrder.new

    @asset = Rails.application.config.asset_base_class_name.constantize.find_by(object_key: params[:asset])
  end

  # GET /maintenance_service_order/1/complete
  def complete

    add_breadcrumb @maintenance_service_order, maintenance_service_order_path(@maintenance_service_order)
    add_breadcrumb "Close out work order"

  end

  # GET /maintenance_service_order/1/edit
  def edit

    add_breadcrumb @maintenance_service_order, maintenance_service_order_path(@maintenance_service_order)
    add_breadcrumb "Update"

  end

  # POST /maintenance_service_orders
  def create

    add_breadcrumb "New"

    @maintenance_service_order = MaintenanceServiceOrder.new(maintenance_service_order_params)
    @maintenance_service_order.organization = @maintenance_service_order.send(Rails.application.config.asset_base_class_name.underscore).organization

    if @maintenance_service_order.save
      # Insert the maintenance events for the asset
      asset = Rails.application.config.asset_base_class_name.constantize.get_typed_asset(@maintenance_service_order.send(Rails.application.config.asset_base_class_name.underscore))
      # one time work order otherwise based on schedule
      if params[:maintenance_activity_types]
        activities = params[:maintenance_activity_types]
      else
        activities = asset.services_required
      end
      activities = [activities] unless activities.kind_of?(Array)

      activities.each do |s|
        event = MaintenanceEvent.new
        event.send("#{Rails.application.config.asset_base_class_name.underscore}=", @maintenance_service_order.send(Rails.application.config.asset_base_class_name.underscore))
        event.maintenance_provider = @maintenance_service_order.maintenance_provider if @maintenance_service_order.maintenance_provider
        if params[:maintenance_activity_types]
          event.maintenance_activity_type_id = s.first
        else
          event.maintenance_activity = s[:activity]
        end
        event.maintenance_service_order = @maintenance_service_order

        if params[:month].to_i || params[:due_date]
          event.due_date = params[:due_date] || Date.new(params[:year].to_i, params[:month].to_i, 1)
        else
          event.due_date = @maintenance_service_order.order_date
        end

        event.save!
      end

      notify_user(:notice, "Work order was successfully created.")
      redirect_back(fallback_location: maintenance_service_order_url(@maintenance_service_order))
    end
  end

  # PATCH/PUT /maintenance_providers/1
  def update

    add_breadcrumb @maintenance_service_order, maintenance_service_order_path(@maintenance_service_order)
    add_breadcrumb "Update"

    if @maintenance_service_order.update(maintenance_service_order_params)
      notify_user(:notice, "Work order was successfully updated.")
      redirect_to maintenance_service_order_url @maintenance_service_order
    else
      render :edit
    end
  end

  # PATCH/PUT /maintenance_providers/1
  def update_service_status

    add_breadcrumb @maintenance_service_order, maintenance_service_order_path(@maintenance_service_order)
    add_breadcrumb "Update work order service status"

    if @maintenance_service_order.update(maintenance_service_order_params)
      # need to go through and set the transients
      @maintenance_service_order.maintenance_events.each do |evt|
        evt.miles_at_service = @maintenance_service_order.miles_at_service
        evt.event_date = @maintenance_service_order.event_date
        evt.completed_by = current_user
        evt.save
        unless evt.comment.blank?
          comment = evt.comments.build({:comment => evt.comment, :creator => current_user})
          comment.save
        end
      end
      notify_user(:notice, "Work order was successfully updated.")
      redirect_to maintenance_service_order_url @maintenance_service_order
    else
      render :edit
    end
  end

  # DELETE /maintenance_providers/1
  def destroy
    @maintenance_service_order.destroy
    notify_user(:notice, "Work order was successfully removed.")
    redirect_to maintenance_service_orders_url
  end

  private

    def reformat_date_field
      date_str = params[:maintenance_service_order][:order_date]
      unless date_str.blank?
        form_date = Date.strptime(date_str, '%m/%d/%Y')
        params[:maintenance_service_order][:order_date] = form_date.strftime('%Y-%m-%d')
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_service_order
      @maintenance_service_order = MaintenanceServiceOrder.find_by_object_key(params[:id])
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_asset
      @asset = Rails.application.config.asset_base_class_name.constantize.get_typed_asset(@maintenance_service_order.send(Rails.application.config.asset_base_class_name.underscore))
    end

    # Only allow a trusted parameter "white list" through.
    def maintenance_service_order_params
      params.require(:maintenance_service_order).permit(MaintenanceServiceOrder.allowable_params)
    end
end
