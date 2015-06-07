require 'rails_helper'

RSpec.describe "cruises/new", type: :view do
  before(:each) do
    assign(:cruise, build(:cruise))
  end

  it "renders new cruise form" do
    render

    assert_select "form[action=?][method=?]", cruises_path, "post" do

      assert_select "input#cruise_name[name=?]", "cruise[name]"

      assert_select "textarea#cruise_description[name=?]", "cruise[description]"

      assert_select "select#cruise_ship_id[name=?]", "cruise[ship_id]"
    end
  end
end
