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
  belongs_to  :transam_asset

  # Every maintenance event is recorded against a specific maintenance provider
  belongs_to  :maintenance_provider

  # ------------------------------------------------------------------------------
  # :maintenance_activity_action    the work to be performed; this can be tied to a schedule or one-time work
  # ------------------------------------------------------------------------------
  # Every maintenance event is recorded against a specific activity if on a schedule
  belongs_to  :maintenance_activity

  # Every maintenance event has an activity type of the work to be performed if
  belongs_to :maintenance_activity_type
  # ------------------------------------------------------------------------------


  # Every maintenance event can be recorded against a workorder
  belongs_to  :maintenance_service_order
  
  # Every maintenance activity is completed by someone
  belongs_to  :completed_by,  :class_name => 'User', :foreign_key => :completed_by_id

  has_many    :comments,    :as => :commentable  
  has_many    :documents,   :as => :documentable

  #------------------------------------------------------------------------------
  # Transients
  #------------------------------------------------------------------------------        
  attr_accessor :comment

  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        
    
  validates Rails.application.config.asset_base_class_name.foreign_key.to_sym,                     :presence => true
  #validates :maintenance_provider,      :presence => true
  #validates :maintenance_activity,      :presence => true
  #validates :event_date,                :presence => true
  #validates :labor_cost,                :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  #validates :parts_cost,                :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  #validates :miles_at_service,          :presence => true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  #validates :completed_by,              :presence => true
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  # default scope
  default_scope { order("event_date") }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :id,
    :asset_id,
    :transam_asset_id,
    :maintenance_provider_id,
    :maintenance_activity_id,
    :maintenance_activity_type_id,
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
    if labor_cost.nil? 
      parts_cost
    else
      labor_cost + parts_cost
    end
  end    

  # try custom work first, then try one activity type, then try activity as part of a schedule
  def to_s

    try(:name) || maintenance_activity_type.try(:to_s) || maintenance_activity.maintenance_activity_type.try(:to_s)
  end

  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new asset event
  def set_defaults
  end
end
