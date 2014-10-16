Rails.application.routes.draw do

  resources :maintenance_schedules

  resources :maintenance_calendars, :only => [:index]
  
end
