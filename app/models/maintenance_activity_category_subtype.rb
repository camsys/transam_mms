class MaintenanceActivityCategorySubtype < ApplicationRecord

  belongs_to :maintenance_activity_category_type
  has_many :maintenance_activity_types

  # Active scope -- always use this scope in forms
  scope :active, -> { where(active: true) }

  def to_s
    name
  end
end
