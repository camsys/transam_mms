#------------------------------------------------------------------------------
#
# MaintenanceProvider
#
# Injects methods and associations for associating Maintenance Schedules with
# organizations.
#
# Usage:
#   Add the following line to an organization class
#
#   include TransamMaintenanceProvider
#
# To perform a run-time check to see if an organization has the maintenance_provider
# role use
#
# @organization.type_of? :transam_maintenance_provider
#
#------------------------------------------------------------------------------
module TransamMaintenanceProvider
  extend ActiveSupport::Concern
  
  included do

    # ----------------------------------------------------  
    # Associations
    # ----------------------------------------------------  

    # Each organization has 0 or more maintenance schedules
    has_many  :maintenance_schedules, :foreign_key => :organization_id

    # Each organization has 0 or more maintenance serice orders
    has_many  :maintenance_service_orders, :foreign_key => :organization_id

    # Each organization has 0 or more maintenance providers
    has_many  :maintenance_providers, :foreign_key => :organization_id
       
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
  
  # returns true if this instance has a maintenance schedule, false
  # otherwise
  def has_maintenance_schedules?
    maintenance_schedules.count > 0
  end
        
end
