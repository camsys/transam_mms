class ChangeMediumPriorityType < ActiveRecord::DataMigration
  def up
    MaintenancePriorityType.find_by(name: 'Normal').update!(name: 'Medium')
  end
end