class AddSortOrderToMaintenancePriorityTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_priority_types, :sort_order, :integer
  end
end
