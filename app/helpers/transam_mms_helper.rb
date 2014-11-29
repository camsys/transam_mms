module TransamMmsHelper

  # Returns the correct icon for a workflow asset
  def get_event_icon(event_name)
    
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