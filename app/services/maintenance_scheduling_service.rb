#------------------------------------------------------------------------------
#
# MaintenanceSchedulingService
#
# Determines the next date that an asset needs a service for an activity
#
#
#------------------------------------------------------------------------------
class MaintenanceSchedulingService

  # Identifies which assets have services due starting this week.
  def services_due(organization_ids)
    connection = ActiveRecord::Base.connection
    results = connection.execute('SELECT DISTINCT(asset_id) FROM assets_maintenance_schedules')
    asset_ids = []
    results.each do |r|
      asset_ids << r[0]
    end
    Rails.logger.debug "Found #{asset_ids.count} assets"
    Rails.logger.debug asset_ids.inspect
    results = []

    assets = Rails.application.config.asset_base_class_name.constantize.where(organization_id: organization_ids, id: asset_ids)
    assets.each do |a|
      asset = Rails.application.config.asset_base_class_name.constantize.get_typed_asset(a)
      asset.maintenance_schedules.each do |schedule|
        schedule.maintenance_activities.each do |activity|
          next_due = next_service_due(asset, activity)
          results << {:asset => asset, :schedule => schedule, :activity => activity, :service_due => next_due}
        end
      end
    end

    Rails.logger.debug results.inspect

    results
  end
  # Determines when the next service is due for an activity for the specified asset. The result of the
  # analysis is a hash:
  #
  # :units => 'miles' | 'days'
  # :due => x
  # :overdue -=> true | false
  #
  # where x is the number of miles or date of next service
  #
  def next_service_due(asset, activity)
    return if asset.nil?
    return if activity.nil?

    asset = Rails.application.config.asset_base_class_name.constantize.get_typed_asset(asset)

    # Get the service interval
    #service_interval = activity.maintenance_service_interval_type
    Rails.logger.debug activity.inspect

    # determine if the service interval is based on miles
    is_miles = activity.is_miles?
    Rails.logger.debug is_miles

    # determine if the service interval is repeating
    is_repeating = activity.is_repeating?
    Rails.logger.debug is_repeating

    # Get the last time this activity was performed for the asset
    service_event = asset.last_service(activity)
    Rails.logger.debug service_event.inspect
    # If the event is non-repeating and has been performed
    # we are done
    if activity.is_repeating? == false and service_event
      a = {}
      a[:units]   = is_miles ? 'miles' : 'days'
      a[:due]     = nil
      a[:overdue] = false
      a[:last_service] = service_event
      return a
    end

    if service_event.present?
      last_event_miles = service_event.miles_at_service
      last_event_date  = service_event.event_date
    else
      # This activity has never been performed so default to the in service date
      last_event_miles = 0
      last_event_date = asset.in_service_date
    end

    # Calculate the next service
    overdue = false
    current_mileage = asset.reported_mileage.nil? ? 0 : asset.reported_mileage
    Rails.logger.debug current_mileage
    if is_miles
      next_service_miles = last_event_miles + activity.interval
      if next_service_miles < current_mileage
        overdue = true
      end
    else
      days_to_next_service = activity.interval * activity.maintenance_service_interval_type.convert_to_days
      next_service_date  = last_event_date + days_to_next_service.round(0).days
      if next_service_date < Date.current
        overdue = true
      end
    end

    # Generate the results
    a = {}
    a[:units]   = is_miles ? 'miles' : 'days'
    a[:due]     = is_miles ? next_service_miles : next_service_date
    a[:overdue] = overdue
    a[:last_service] = service_event

    # Return the hash
    a
  end
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  #------------------------------------------------------------------------------
  #
  # Private Methods
  #
  #------------------------------------------------------------------------------
  private

end
