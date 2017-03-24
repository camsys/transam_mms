class AddMaintenanceActivityTypeMaintenanceEvents < ActiveRecord::Migration
  def change
    add_reference :maintenance_events, :maintenance_activity_type, index: true
  end
end
