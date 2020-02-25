class AddSortOrdersToMmsMaintenancePriorityTypes < ActiveRecord::DataMigration
  def up
    orders = {
        'Low': 1,
        'Medium': 2,
        'High': 3
    }

    orders.each do |p,o|
      MaintenancePriorityType.find_by(name: p).update(sort_order: o)
    end
  end
end