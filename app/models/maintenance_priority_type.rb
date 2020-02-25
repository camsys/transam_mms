class MaintenancePriorityType < ApplicationRecord

  # All types that are available
  scope :ordered, -> { order(:sort_order) }
  scope :active, -> { ordered.where(:active => true) }

  def self.default
    find_by(:is_default => true)
  end

  def to_s
    name
  end


end
