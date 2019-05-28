class AddMmsSystemConfigExtensions < ActiveRecord::DataMigration
  def up
    SystemConfigExtension.create!(class_name: 'TransamAsset', extension_name: 'TransamMaintainable', engine_name: 'mms', active: true)
    SystemConfigExtension.create!(class_name: 'Organization', extension_name: 'TransamMaintenanceProvider', engine_name: 'mms', active: true)
  end
end