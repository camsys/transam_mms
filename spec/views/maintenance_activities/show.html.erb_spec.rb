require 'rails_helper'

RSpec.describe "maintenance_activities/show", :type => :view do
  before(:each) do
    @maintenance_activity = assign(:maintenance_activity, MaintenanceActivity.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
