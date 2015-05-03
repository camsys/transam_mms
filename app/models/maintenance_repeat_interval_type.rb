class MaintenanceRepeatIntervalType < ActiveRecord::Base

  # Active scope -- always use this scope in forms
  scope :active, -> { where(active: true) }
  
  def to_s
    name
  end

  def is_repeating?
    name == 'every'
  end
end
