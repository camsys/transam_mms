class AddCostToMaintenanceEvent < ActiveRecord::Migration
  def change
    add_column    :maintenance_events, :parts_cost, :integer, :after => :event_date
    add_column    :maintenance_events, :labor_cost, :integer, :after => :parts_cost
    
  end
end
