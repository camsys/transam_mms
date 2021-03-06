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

  # Has 0 or more maintenance activities. These will be removed if the maintenance schedule is removed.
  has_many    :maintenance_activities, :dependent => :destroy

  # Each schedule is used by 0 or more assets
  has_and_belongs_to_many       :assets, join_table: :assets_maintenance_schedules, class_name: Rails.application.config.asset_base_class_name

   # Use a nested form to set the activities
  accepts_nested_attributes_for :maintenance_activities, :allow_destroy => true

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

  # Allow selection of active instances
  scope :active, -> { where(:active => true) }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :organization_id,
    :asset_subtype_id,
    :name,
    :description,
    :active,
    :maintenance_activities_attributes => [MaintenanceActivity.allowable_params]

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
