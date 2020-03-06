module Abilities
  class MaintenanceMgmtPrivilege
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can :manage, MaintenanceServiceOrder do |order|
        organization_ids.include? order.organization_id
      end

    end
  end
end