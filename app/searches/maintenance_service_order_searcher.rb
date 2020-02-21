#------------------------------------------------------------------------------
#
# Maintenance Service Order Searcher
#
# Concrete implementation that returns maintenance service orders
#
#------------------------------------------------------------------------------
class MaintenanceServiceOrderSearcher < BaseSearcher

  attr_accessor :search_proxy
  attr_accessor :priority_type

  # Return the name of the form to display
  def form_view
    'maintenance_service_order_search_form'
  end
  # Return the name of the results table to display
  def results_view
    'maintenance_service_order_search_results_table'
  end

  def cache_variable_name
    MaintenanceServiceOrdersController::INDEX_KEY_LIST_VAR
  end

  def initialize(attributes = {})
    super(attributes)
  end

  private

  def priority_type_conditions
    clean_priority_types = remove_blanks(search_proxy&.priority_type)
    MaintenanceServiceOrder.where(priority_type_id: clean_priority_types) unless clean_priority_types.blank?
  end

end

