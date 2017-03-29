class MaintenanceProvidersController < OrganizationAwareController
  
  add_breadcrumb "Home", :root_path
  add_breadcrumb "Maintenance Providers", :maintenance_providers_path
  
  before_action :set_maintenance_provider, :only => [:show, :edit, :update, :destroy, :add_asset, :remove_asset]

  def add_asset
    
    asset = Asset.find_by_object_key(params[:asset])
    if asset.nil?
      notify_user(:alert, "The asset could not be found.")
    elsif @maintenance_provider.assets.include? asset
      notify_user(:alert, "The asset is already in #{@maintenance_provider} list.")
    else
      notify_user(:notice, "The asset was added to #{@maintenance_provider} list.")
      @maintenance_provider.assets << asset
    end

    redirect_to :back
    return
  end

  def remove_asset
    
    asset = @maintenance_provider.assets.find_by_object_key(params[:asset])
    if asset.nil?
      notify_user(:alert, "The asset could not be found.")
    else
      notify_user(:notice, "The asset was removed from the #{@maintenance_provider} program.")
      @maintenance_provider.assets.destroy asset
    end

    redirect_to :back
    return
  end

  def index
    @maintenance_providers = MaintenanceProvider.where(organization_id: @organization_list)
  end
  
  def show
    add_breadcrumb @maintenance_provider
    
  end
  # GET /maintenance_providers/new
  def new
    
    add_breadcrumb "New"

    @maintenance_provider = MaintenanceProvider.new
  end

  # GET /maintenance_providers/1/edit
  def edit

    add_breadcrumb @maintenance_provider, maintenance_provider_path(@maintenance_provider)
    add_breadcrumb "Update"

  end

  # POST /maintenance_providers
  def create

    add_breadcrumb "New"
    
    @maintenance_provider = MaintenanceProvider.new(maintenance_provider_params)
    @maintenance_provider.organization_id = @organization_list.first if @organization_list.count == 1
    
    if @maintenance_provider.save
      notify_user(:notice, "Maintenance provider was successfully created.")
      redirect_to maintenance_provider_url @maintenance_provider
    else
      render :new
    end
  end

  # PATCH/PUT /maintenance_providers/1
  def update
    
    add_breadcrumb @maintenance_provider, maintenance_provider_path(@maintenance_provider)
    add_breadcrumb "Update"
    
    if @maintenance_provider.update(maintenance_provider_params)
      notify_user(:notice, "Maintenance provider was successfully updated.")
      redirect_to maintenance_provider_url @maintenance_provider
    else
      render :edit
    end
  end

  # DELETE /maintenance_providers/1
  def destroy
    @maintenance_provider.destroy
    notify_user(:notice, "Maintenance provider was successfully removed.")
    redirect_to maintenance_providers_url 
  end

  private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_maintenance_provider
      @maintenance_provider = MaintenanceProvider.find_by_object_key(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def maintenance_provider_params
      params.require(:maintenance_provider).permit(MaintenanceProvider.allowable_params)
    end
end
