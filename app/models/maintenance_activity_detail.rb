#------------------------------------------------------------------------------
#
# MaintenanceActivityDetail
#
# Maps a maintenance schedule to maintenance activities and provides the established
# service interval in terms of miles, hours use, or time
#
#------------------------------------------------------------------------------
class MaintenanceActivityDetail < ActiveRecord::Base
      
  # Include the object key mixin
  include TransamObjectKey

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------        
  after_initialize :set_defaults

  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------        
  belongs_to :maintenance_schedule
  belongs_to :maintenance_activity
  
  has_many   :service_intervals
  
  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        
  
  validates :name,                      :presence => true
  validates :description,               :presence => true
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :maintenance_schedule_id,
    :maintenance_activity_id,
    :name,
    :description,
    :required_by_manufacturer,
    :active
  ]
  
  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------
    
  def self.allowable_params
    FORM_PARAMS
  end
  
  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------
      
  
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new asset event
  def set_defaults
    self.required_by_manufacturer ||= true
  end
end
