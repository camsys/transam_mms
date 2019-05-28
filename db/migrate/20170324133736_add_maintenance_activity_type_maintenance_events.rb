class AddMaintenanceActivityTypeMaintenanceEvents < ActiveRecord::Migration[4.2]
  def change
    add_reference :maintenance_events, :maintenance_activity_type, index: true
  end
end
