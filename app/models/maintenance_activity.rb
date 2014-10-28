#------------------------------------------------------------------------------
#
# MaintenanceActivity
#
# Identifies a maintenance activity that is part of a maintenance schedule.
#
#------------------------------------------------------------------------------
class MaintenanceActivity < ActiveRecord::Base
      
  # Include the object key mixin
  include TransamObjectKey

  # Include the numeric sanitizers mixin
  include TransamNumericSanitizers

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------        
  after_initialize :set_defaults

  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------        
  # Each one belongs to a schedule
  belongs_to :maintenance_schedule
  
  # Each one has an activity type
  belongs_to :maintenance_activity_type
  
  # Each one has a repeat interval type eg every, at, 
  belongs_to  :maintenance_repeat_interval_type
  
  # Each one has a repeat service interval type eg miles, hours, weeks, days, months, years,
  belongs_to  :maintenance_service_interval_type
  
  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        
  validates :maintenance_schedule,        :presence => true  
  validates :maintenance_activity_type,   :presence => true  
  validates :maintenance_repeat_interval_type,        :presence => true  
  validates :maintenance_service_interval_type,       :presence => true 
  validates :interval,                    :presence => true, :numericality => {:only_integer => :true, :greater_than_or_equal_to => 0}
   
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :maintenance_schedule_id,
    :maintenance_activity_type_id,
    :maintenance_repeat_interval_type_id,
    :maintenance_service_interval_type_id,
    :interval,
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
      
  def to_s
    maintenance_activity_type.to_s
  end
  
  def service_interval
    "#{maintenance_repeat_interval_type} #{interval} #{maintenance_service_interval_type}"
  end
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
