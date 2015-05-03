#------------------------------------------------------------------------------
#
# MaintenanceActivityType
#
# Represents a type of maintenance activity that can be performed on an asset, for example
# change the oil, rotate the tires, etc.
#
#------------------------------------------------------------------------------
class MaintenanceActivityType < ActiveRecord::Base

  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------

  validates :name,                      :presence => true
  validates :description,               :presence => true

  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------

  # Active scope -- always use this scope in forms
  scope :active, -> { where(active: true) }

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

end
