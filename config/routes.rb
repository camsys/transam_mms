Rails.application.routes.draw do


  resources :maintenance_schedules do
    resources :maintenance_activities, :only => [:create, :update, :edit, :new, :destroy]    
    member do
      get 'add_asset'
      get 'remove_asset'
    end
  end

  resources :maintenance_calendars, :only => [:index]
  
  resources :inventory, :controller => 'assets' do
    resources :maintenance_events    
  end
    
end
