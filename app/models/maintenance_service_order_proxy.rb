#-------------------------------------------------------------------------------
# MaintenanceServiceOrderProxy
#
# Proxy class for gathering maintenance_service_order search parameters
#
#-------------------------------------------------------------------------------
class MaintenanceServiceOrderProxy < Proxy

  #-----------------------------------------------------------------------------
  # Attributes
  #-----------------------------------------------------------------------------
  # new_search: Flag to indicate if the search has been reset or is new. Values are '1' (new search) or '0'
  attr_accessor   :new_search, :priority_type

  #-----------------------------------------------------------------------------
  # Validations
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Constants
  #-----------------------------------------------------------------------------

  # List of allowable form param hash keys

  FORM_PARAMS = [

  ]

  NESTED_FORM_PARAMS = [
      { :priority_type => [] }
  ]

  #-----------------------------------------------------------------------------
  #
  # Class Methods
  #
  #-----------------------------------------------------------------------------

  def self.allowable_params
    FORM_PARAMS + NESTED_FORM_PARAMS
  end

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------

  #-----------------------------------------------------------------------------
  # Returns the search proxy as hash as if a form had been submitted
  #-----------------------------------------------------------------------------
  def to_h
    h = {}
    a = {}
    FORM_PARAMS.each do |param|
      a[param] = self.try(param) unless self.try(param).blank?
    end

    NESTED_FORM_PARAMS.each do |param|
      p_key = param.keys.first
      a[p_key] = self.try(p_key) unless self.try(p_key).blank?
    end

    h[:maintenance_service_order_proxy] = a
    h.with_indifferent_access
  end

  #-----------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #-----------------------------------------------------------------------------
  protected

  def initialize(attrs = {})
    super
    attrs.each do |k, v|
      self.send "#{k}=", v
    end

    self.new_search ||= '1'
  end

end