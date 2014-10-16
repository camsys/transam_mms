#------------------------------------------------------------------------------
#
# ServiceInterval
#
# Represents a service interval for an activity, for example
#   every 5,000 miles
#   at 90,000 miles
#   every 100 hours
#
#------------------------------------------------------------------------------
class ServiceInterval < ActiveRecord::Base
      
  # Include the object key mixin
  include TransamObjectKey

  # Include the numeric sanitizers mixin
  include NumericSanitizers

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------        
  after_initialize :set_defaults

  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------        
  
  # Every service interval belongs to maintenance activity detail
  belongs_to  :maintenance_activity_detail

  # Every service interval belongs to repeat interval type eg every, at, 
  belongs_to  :repeat_interval_type
  
  # Every service interval belongs to service interval type eg miles, hours, weeks, days, months, years,
  belongs_to  :service_interval_type
    
  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        
  
  validates :maintenance_activity_detail, :presence => true
  validates :service_interval_type,       :presence => true
  validates :repeat_interval_type,        :presence => true
  validates :interval,                    :presence => true
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :maintenance_activity_detail_id,
    :service_interval_type_id,
    :repeat_interval_type_id,
    :interval
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
    name
  end
  
  def name
    "#{repeat_interval_type} #{interval} #{service_interval_type}"
  end
  
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new service interval
  def set_defaults
  end
end
