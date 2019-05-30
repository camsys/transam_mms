class AssetsMaintenanceSchedule < ActiveRecord::Base

  belongs_to :asset
  belongs_to :transam_asset
  belongs_to :maintenance_schedule


end