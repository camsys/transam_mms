#------------------------------------------------------------------------------
#
# MaintenanceServiceOrder
#
# Represents a service order for performing maintenance on an asset. Each workorder
# goes through a work flow
#
#------------------------------------------------------------------------------
class MaintenanceServiceOrder < ActiveRecord::Base
      
  # Include the object key mixin
  include TransamObjectKey

  # Include the Workflow module
  include TransamWorkflow

  #------------------------------------------------------------------------------
  # Callbacks
  #------------------------------------------------------------------------------        
  after_initialize :set_defaults

  # Always generate a unique workorder number when the workorder is created
  after_create do
    create_workorder_number
  end

  #------------------------------------------------------------------------------
  # Associations
  #------------------------------------------------------------------------------        
  
  # Every workorder belongs to an orgnization
  belongs_to  :organization

  # Every workorder belongs to an asset
  belongs_to  :asset

  # Every workorder is sent to a specific maintenance provider
  belongs_to  :maintenance_provider
  
  # Every workorder has a set of maintenance events
  has_many    :maintenance_events
  
  # Every workorder can have comments
  has_many    :comments,    :as => :commentable  
  
  # Every workorder can have documents
  has_many    :documents,   :as => :documentable

  #------------------------------------------------------------------------------
  # Validations
  #------------------------------------------------------------------------------        

  validates :organization,              :presence => true
  validates :asset,                     :presence => true
  validates :maintenance_provider,      :presence => true
  validates :order_date,                :presence => true
  
  #------------------------------------------------------------------------------
  # Scopes
  #------------------------------------------------------------------------------        
    
  # default scope
  default_scope { order(:order_date) }

  # List of hash parameters allowed by the controller
  FORM_PARAMS = [
    :organization_id,
    :asset_id,
    :maintenance_provider_id,
    :order_date
  ]
  #------------------------------------------------------------------------------
  #
  # State Machine 
  #
  # Used to track the state of a service order through the completion process
  #
  #------------------------------------------------------------------------------  
  state_machine :state, :initial => :pending do

    #-------------------------------
    # List of allowable states
    #-------------------------------
    
    # initial state. All workorders are created in this state
    state :pending

    # state used to signify it has been transmitted
    state :transmitted
    
    # state used to signify it has been accepted
    state :accepted

    # state used to signify that work has started
    state :started

    # state used to indicate the workorder has been completed
    state :completed

    #---------------------------------------------------------------------------
    # List of allowable events. Events transition a CP from one state to another
    #---------------------------------------------------------------------------
            
    # Retract the workorder from the shop
    event :retract do
      transition [:transmitted, :accepted] => :pending
    end

    # transmit a workorder 
    event :transmit do
      
      transition :pending => :transmitted
      
    end

    # A service manager is accepting a workorder
    event :accept do
      
      transition :transmitted => :accepted
      
    end    

    # The workorder has been started
    event :start do
      
      transition :accepted => :started
      
    end    

    # The workorder has been completed
    event :complete do
      
      transition :started => :completed
      
    end    
    
    # Callbacks
    before_transition do |project, transition|
      Rails.logger.debug "Transitioning #{project.name} from #{transition.from_name} to #{transition.to_name} using #{transition.event}"
    end       
  end
  
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
  
  def name
    workorder_number
  end
  #------------------------------------------------------------------------------
  #
  # Protected Methods
  #
  #------------------------------------------------------------------------------
  protected

  def create_workorder_number
    workorder_number = sprintf("MS%06d", id)
    self.update_attributes(:workorder_number => workorder_number)      
  end

  # Set resonable defaults for a new asset event
  def set_defaults
    self.order_date ||= Date.today
    self.state ||= :pending
  end
end