#------------------------------------------------------------------------------
#
# MaintenanceSchedule
#
# Represents a maintenance schedule for an asset class in TransAM. Each maintenance
# schedule is composed of a set of maintenance activities and a schedule for each
# activity for example:
#
#   Oil Change:    5000 miles or 6 months
#   Tire Rotation: 5000 miles or 6 months
#   Replace air conditioning filter: 10000 miles
#
#------------------------------------------------------------------------------
class MaintenanceSchedule < ActiveRecord::Base
    
  # Include the object key mixin
  include TransamObjectKey
    
  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------
  after_initialize  :set_defaults
              
  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------
  # Every maintenance schedule belongs to an organization
  belongs_to  :organization
  
  # Every maintenance schedule is associated with an asset subtype  
  belongs_to  :asset_subtype
  
  # Has 0 or more maintenance activity details. These will be removed if the maintenance schedule is removed.
  has_many    :maintenance_activity_details, :dependent => :destroy

  # Each schedule is used by 0 or more assets
  has_many    :assets
    
   # Use a nested form to set the activities
  accepts_nested_attributes_for :maintenance_activity_details, :allow_destroy => true

  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------
  validates :organization,                      :presence => true
  validates :asset_subtype,                     :presence => true
  validates :name,                              :presence => true
  validates :description,                       :presence => true

  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------
  
  # default scope
  default_scope { where(:active => true) }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :organization_id,
    :asset_subtype_id,
    :name,
    :description,
    :active,
    :maintenance_activity_details_attributes => [MaintenanceActivityDetail.allowable_params]
    
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
  
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected 

  # Set resonable defaults for a new capital project
  def set_defaults
    self.active ||= true
  end    
            
end
