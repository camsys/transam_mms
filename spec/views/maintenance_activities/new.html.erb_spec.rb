require 'rails_helper'

RSpec.describe "maintenance_activities/new", :type => :view do
  before(:each) do
    assign(:maintenance_activity, MaintenanceActivity.new())
  end

  it "renders new maintenance_activity form" do
    render

    assert_select "form[action=?][method=?]", maintenance_activities_path, "post" do
    end
  end
end
