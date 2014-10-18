Rails.application.routes.draw do


  resources :maintenance_schedules do
    resources :maintenance_activities, :only => [:create, :update, :edit, :new, :destroy]    
  end

  resources :maintenance_calendars, :only => [:index]
  
end
