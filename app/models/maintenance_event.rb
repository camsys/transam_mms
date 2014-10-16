#------------------------------------------------------------------------------
#
# MaintenanceEvent
#
# Represents a service being performed on an asset by a person on a given date
#
#------------------------------------------------------------------------------
#
# MaintenanceEvent
#
# Records a service being performed on an asset
#
class MaintenanceEvent < ActiveRecord::Base
      
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
  
  # Every maintenance activity belongs to an asset
  belongs_to  :asset
  
  # Every maintenance event is recorded against a specific activity
  belongs_to  :maintenance_activity
  
  # Every maintenance activity is completed by someone
  belongs to  :completed_by,  :class => :user, :foreign_key => :completed_by_id
  
  has_many    :comments,    :as => :commentable  
  has_many    :documents,   :as => :documentable
  
  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        
  
  validates :asset,                     :presence => true
  validates :maintenance_activity,      :presence => true
  validates :activity_date,             :presence => true
  validates :miles_at_service,          :presence => true
  validates :completed_by,              :presence => true
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  # default scope
  default_scope { order("activity_date") }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :asset_id,
    :maintenance_activity_type_id,
    :activity_date,
    :miles_at_service,
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
    self.activity_date ||= Date.today
  end
end
