require 'rails_helper'

RSpec.describe "maintenance_activities/index", :type => :view do
  before(:each) do
    assign(:maintenance_activities, [
      MaintenanceActivity.create!(),
      MaintenanceActivity.create!()
    ])
  end

  it "renders a list of maintenance_activities" do
    render
  end
end
