#------------------------------------------------------------------------------
#
# Maintainable
#
# Injects methods and associations for associating Maintenance Schedules with
# assets.
#
# Usage:
#   Add the following line to an asset class
#
#   Include TransamMaintainable
#
#------------------------------------------------------------------------------
module TransamMaintainable
  extend ActiveSupport::Concern

  included do

    # ----------------------------------------------------
    # Associations
    # ----------------------------------------------------

    # Each maintainable asset has 0 or more maintenance schedules
    has_and_belongs_to_many :maintenance_schedules, :join_table => :assets_maintenance_schedules, :foreign_key => Rails.application.config.asset_base_class_name.foreign_key

    # Each maintainable asset has 0 or more maintenance providers
    has_and_belongs_to_many :maintenance_providers, :join_table => :assets_maintenance_providers, :foreign_key => Rails.application.config.asset_base_class_name.foreign_key

    # Each maintainable asset has 0 or more maintenance providers
    has_many  :maintenance_service_orders, :foreign_key => Rails.application.config.asset_base_class_name.foreign_key

    # A list of completed maintenance activities
    has_many  :maintenance_events, :foreign_key => Rails.application.config.asset_base_class_name.foreign_key, :dependent => :destroy

    # ----------------------------------------------------
    # Validations
    # ----------------------------------------------------

  end

  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------

  module ClassMethods

  end

  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------

  # Render the asset as a JSON object -- overrides the default json encoding
  def as_json(options={})
    super.merge(
    {
      :services_required => self.service_required?
    })
  end

  # Returns an array of services that are required
  def services_required
    a = []
    unless maintenance_schedule.nil?

      service = MaintenanceSchedulingService.new

      maintenance_schedule.maintenance_activities.each do |activity|
        a << {:activity => activity, :service_due => service.next_service_due(self, activity), :last_service => last_service(activity)}
      end
    end
    a
  end

  def service_required?
    (services_required.count > 0)
  end

  # returns true if this instance has a maintenance schedule, false
  # otherwise
  def maintainable?
    true
  end

  # There is only one maintenance schedule
  def maintenance_schedule
    if maintenance_schedules
      maintenance_schedules.first
    else
      nil
    end
  end

  # Returns the last service for an activity
  def last_service(activity, is_scheduled=true)
    if is_scheduled
      maintenance_events.where(maintenance_activity_id: activity.id).where.not(event_date: '').order(:event_date).last
    else
      maintenance_events.where(maintenance_activity_type_id: activity.id).where.not(event_date: '').order(:event_date).last
    end
  end

  # Returns the maintenance history for an asset
  def maintenance_history
    maintenance_events.where.not(event_date: '').order(event_date: :desc)
  end

end
