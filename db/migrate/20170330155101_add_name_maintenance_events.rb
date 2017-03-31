class AddNameMaintenanceEvents < ActiveRecord::Migration
  def change
    add_column :maintenance_events, :name, :string
  end
end
