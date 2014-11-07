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
  validates :labor_cost,                :presence => true, :numericality => {:only_integer => :true, :greater_than_or_equal_to => 0}
  validates :parts_cost,                :presence => true, :numericality => {:only_integer => :true, :greater_than_or_equal_to => 0}
  validates :miles_at_service,          :presence => true, :numericality => {:only_integer => :true, :greater_than_or_equal_to => 0}
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
    :labor_cost,
    :parts_cost,
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
  def total_cost
    labor_cost + parts_cost
  end    
  
  def to_s
    name
  end
  def name
    "#{maintenance_activity} on #{event_date}"
  end
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new asset event
  def set_defaults
    self.event_date ||= Date.today
    self.labor_cost ||= 0
    self.parts_cost ||= 0
  end
end
