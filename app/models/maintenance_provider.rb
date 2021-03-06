#------------------------------------------------------------------------------
#
# MaintenanceProvider
#
# Represents a vendor who performs maintenance services on assets
#
#------------------------------------------------------------------------------
class MaintenanceProvider < ActiveRecord::Base
      
  # Include the object key mixin
  include TransamObjectKey
      
  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------        
  after_initialize  :set_defaults

  # Enable automatic geocoding using the Geocoder gem
  geocoded_by       :full_address
  after_validation  :geocode  

  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------        
  # Every vendor is owned by an organization
  belongs_to :organization

  # Every provider has 0 or more assets they have serviced
  has_and_belongs_to_many   :assets, join_table: :assets_maintenance_providers, class_name: Rails.application.config.asset_base_class_name

  # Every provider has 0 or more maintenance events they have created
  has_many   :maintenance_events

  # Every provider providses for 0 or more maintenance service orders
  has_many   :maintenance_service_orders
  
  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        
  validates :name,            :presence => true  
  validates :organization,    :presence => true
  validates :manager,         :presence => true
  validates :email,           :presence => true
  
  # List of allowable form param hash keys  
  FORM_PARAMS = [
    :name,
    :organization_id,
    :address1,
    :address2,
    :city,
    :state,
    :zip,
    :phone,
    :fax,
    :url,
    :manager,
    :email,
    :active,
    :latitude,
    :longitude
  ]
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  #------------------------------------------------------------------------------
  #
  # Class Methods
  #
  #------------------------------------------------------------------------------
  def self.allowable_params
    FORM_PARAMS
  end
      
  #------------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #------------------------------------------------------------------------------
  def to_s
    name
  end
  
  def full_address
    elems = []
    elems << address1 unless address1.blank?
    elems << address2 unless address2.blank?
    elems << city unless city.blank?
    elems << state unless state.blank?
    elems << zip unless zip.blank?
    elems.compact.join(', ')    
  end
  
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  # Set resonable defaults for a new organization
  def set_defaults
    self.active ||= true
  end    

end
