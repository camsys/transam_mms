class CreateMaintenancePriorityTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenance_priority_types do |t|
      t.string :name
      t.string :description
      t.boolean :is_default
      t.boolean :active

      t.timestamps
    end
  end
end
