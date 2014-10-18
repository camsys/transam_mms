require "rails_helper"

RSpec.describe MaintenanceActivitiesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/maintenance_activities").to route_to("maintenance_activities#index")
    end

    it "routes to #new" do
      expect(:get => "/maintenance_activities/new").to route_to("maintenance_activities#new")
    end

    it "routes to #show" do
      expect(:get => "/maintenance_activities/1").to route_to("maintenance_activities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/maintenance_activities/1/edit").to route_to("maintenance_activities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/maintenance_activities").to route_to("maintenance_activities#create")
    end

    it "routes to #update" do
      expect(:put => "/maintenance_activities/1").to route_to("maintenance_activities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/maintenance_activities/1").to route_to("maintenance_activities#destroy", :id => "1")
    end

  end
end
