module TransamMmsHelper

  # formats an icon if services are requried
  def format_as_service_required(asset)
    if asset.respond_to? :service_required?
      if asset.service_required?
        return "<i class='fa fa-wrench fa-fw'></i>".html_safe
      end
    end
  end

  # returns true if there is a maintenance service order of the given activity type for the asset
  def is_service_scheduled(asset, activity)
    return false if asset.nil?
    return false if activity.nil?

    events = MaintenanceEvent.where(:asset_id => asset.id, :maintenance_activity_id => activity.id)
    events.each do |evt|
      if evt.event_date.nil?
        if evt.maintenance_service_order
          return true
        end
      end
    end
    false
  end

  # Returns the correct icon for a workflow asset
  def get_mms_event_icon(event_name)

    if event_name == 'retract'
      'fa-reply'
    elsif event_name == 'transmit'
      'fa-share'
    elsif event_name == 'accept'
      'fa-plus-square'
    elsif event_name == 'start'
      'fa-gear'
    elsif event_name == 'complete'
      'fa-chevron-circle-right'
    else
      ''
    end
  end

end
