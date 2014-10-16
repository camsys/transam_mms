module TransamMaintainable
  extend ActiveSupport::Concern
  
  included do

    # ----------------------------------------------------  
    # Associations
    # ----------------------------------------------------  

    # Each maintainable asset has 0 or more maintenance schedules
    has_and_belongs_to_many :maintenance_schedules
       
    # A list of maintenance activities
    has_many  :maintenance_events

    # ----------------------------------------------------  
    # Validations
    # ----------------------------------------------------  
    
    validates :maintenance_schedule, :presence => true
        
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
    maintenance_schedule.empty?
  end
        
  # Returns the maintenance history for an asset
  def maintenance_history
    maintenance_events
  end
        
end
