#------------------------------------------------------------------------------
#
# MaintenanceSchedulingService
#
# Determines the next date that an asset needs a service for an activity
#
#
#------------------------------------------------------------------------------
class MaintenanceSchedulingService
  
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
    
    # Get the service interval
    #service_interval = activity.maintenance_service_interval_type
    
    # determine if the service interval is based on miles
    is_miles = activity.is_miles?
    
    # determine if the service interval is repeating
    is_repeating = activity.is_repeating?
    
    # Get the last time this activity was performed for the asset
    service_event = asset.last_service(activity)

    # If the event is non-repeating and has been performed
    # we are done
    if activity.is_repeating? == false and service_event
      a = {}
      a[:units]   = is_miles ? 'miles' : 'days'
      a[:due]     = nil
      a[:overdue] = false
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
    if is_miles
      next_service_miles = last_event_miles + activity.interval
      if next_service_miles < asset.reported_mileage
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
