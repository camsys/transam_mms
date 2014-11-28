Rails.application.routes.draw do


  resources :maintenance_forecasts, :only => [:index]

  resources :maintenance_service_orders do
    member do
      get 'fire_workflow_event'
    end    
  end

  resources :maintenance_providers do
    member do
      get 'add_asset'
      get 'remove_asset'
    end
  end
  
  resources :maintenance_schedules do
    resources :maintenance_activities, :only => [:create, :update, :edit, :new, :destroy]    
    member do
      get 'add_asset'
      get 'remove_asset'
    end
  end
  
  resources :inventory, :only => [], :controller => 'assets' do
    resources :maintenance_events    
  end
    
end
