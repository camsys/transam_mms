require 'rails_helper'

RSpec.describe "maintenance_activities/edit", :type => :view do
  before(:each) do
    @maintenance_activity = assign(:maintenance_activity, MaintenanceActivity.create!())
  end

  it "renders the edit maintenance_activity form" do
    render

    assert_select "form[action=?][method=?]", maintenance_activity_path(@maintenance_activity), "post" do
    end
  end
end
