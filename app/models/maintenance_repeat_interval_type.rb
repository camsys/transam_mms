class MaintenanceRepeatIntervalType < ActiveRecord::Base
          
  # default scope
  default_scope { where(:active => true) }
  
  def to_s
    name
  end
  
  def is_repeating?
    name == 'every'
  end
end