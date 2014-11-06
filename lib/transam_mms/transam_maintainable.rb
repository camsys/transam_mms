#------------------------------------------------------------------------------
#
# Maintainable
#
# Injects methods and associations for associating Maintenance Schedules with
# assets.
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamMaintainable
#
#------------------------------------------------------------------------------
module TransamMaintainable
  extend ActiveSupport::Concern
  
  included do

    # ----------------------------------------------------  
    # Associations
    # ----------------------------------------------------  

    # Each maintainable asset has 0 or more maintenance schedules
    has_and_belongs_to_many :maintenance_schedules, :foreign_key => :asset_id
       
    # A list of maintenance activities
    has_many  :maintenance_events, :foreign_key => :asset_id, :dependent => :destroy

    # ----------------------------------------------------  
    # Validations
    # ----------------------------------------------------  
    
  end

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  module ClassMethods

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # returns true if this instance has a maintenance schedule, false
  # otherwise
  def maintainable?
    true
  end
  
  # There is only one maintenance schedule
  def maintenance_schedule
    if maintenance_schedules
      maintenance_schedules.first 
    else
      nil
    end
  end
        
  # Returns the maintenance history for an asset
  def maintenance_history
    maintenance_events.order('event_date DESC')
  end
        
end
