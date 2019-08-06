class MaintenanceActivityCategoryType < ApplicationRecord

  has_many :maintenance_activity_category_subtypes

  # Active scope -- always use this scope in forms
  scope :active, -> { where(active: true) }

  def to_s
    name
  end

end
