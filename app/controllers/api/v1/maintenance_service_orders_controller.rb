class Api::V1::MaintenanceServiceOrdersController < Api::ApiController
  before_action :query_maintenance_service_orders

  # GET /maintenance_service_orders
  def index
  end

  private

  def query_maintenance_service_orders
    asset = TransamAsset.find(params[:transam_asset_id])
    if !asset
      @status = :fail
      @data = {asset: "Asset should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @maintenance_service_orders = MaintenanceServiceOrder.where(transam_asset: asset)
  end

end