#------------------------------------------------------------------------------
#
# MaintenanceEvent
#
# Represents a service being performed on an asset by a person on a given date
#
#------------------------------------------------------------------------------
class MaintenanceEvent < ActiveRecord::Base
      
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
  
  # Every maintenance activity belongs to an asset
  belongs_to  :asset
  
  # Every maintenance event is recorded against a specific activity
  belongs_to  :maintenance_activity
  
  # Every maintenance activity is completed by someone
  belongs_to  :completed_by,  :class_name => 'User', :foreign_key => :completed_by_id

  has_many    :comments,    :as => :commentable  
  has_many    :documents,   :as => :documentable
  
  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        

  attr_accessor :comment
    
  validates :asset,                     :presence => true
  validates :maintenance_activity,      :presence => true
  validates :event_date,                :presence => true
  validates :miles_at_service,          :presence => true
  validates :completed_by,              :presence => true
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  # default scope
  default_scope { order("event_date") }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :asset_id,
    :maintenance_activity_id,
    :event_date,
    :miles_at_service,
    :comment,
    :completed_by_id
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
    self.event_date ||= Date.today
  end
end
