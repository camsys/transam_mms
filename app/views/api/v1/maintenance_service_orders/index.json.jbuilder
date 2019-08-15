json.maintenance_service_orders do
  json.partial! 'api/v1/maintenance_service_orders/listing', collection: @maintenance_service_orders, as: :maintenance_service_order
end