class AddMaintenancePriorityTypes < ActiveRecord::DataMigration
  def up
    maintenance_priority_types = [
        {:active => 1, :is_default => 0, :name => 'Low',     :description => 'Lowest priority.'},
        {:active => 1, :is_default => 1, :name => 'Medium',  :description => 'Normal priority.'},
        {:active => 1, :is_default => 0, :name => 'High',    :description => 'Highest priority.'},
    ]

    maintenance_priority_types.each{|m| MaintenancePriorityType.create!(m)}
  end
end