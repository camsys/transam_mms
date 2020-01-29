class AddDateRecommendedServiceOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :maintenance_service_orders, :date_recommended, :date, after: :priority_type_id
  end
end
