class MaintenanceServiceIntervalType < ActiveRecord::Base
          
  # default scope
  default_scope { where(:active => true) }
  
  def to_s
    name
  end
  
  def is_miles?
    name == 'miles'
  end
  
  def convert_to_days
    if name == 'hours'
      1 / 24.0
    elsif name == 'days'
      1.0
    elsif name == 'weeks'
      7.0
    elsif name == 'weeks'
      7.0
    elsif name == 'months'
      365 / 12.0
    elsif name == 'years'
      365
    else
      0
    end
  end
end
