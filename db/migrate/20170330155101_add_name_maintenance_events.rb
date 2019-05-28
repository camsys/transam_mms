class AddNameMaintenanceEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :maintenance_events, :name, :string
  end
end
