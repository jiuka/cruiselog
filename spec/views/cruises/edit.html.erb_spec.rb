require 'rails_helper'

RSpec.describe "cruises/edit", type: :view do
  before(:each) do
    @cruise = assign(:cruise, create(:cruise))
  end

  it "renders the edit cruise form" do
    render

    assert_select "form[action=?][method=?]", cruise_path(@cruise), "post" do

      assert_select "input#cruise_name[name=?]", "cruise[name]"

      assert_select "textarea#cruise_description[name=?]", "cruise[description]"

      assert_select "select#cruise_ship_id[name=?]", "cruise[ship_id]"
    end
  end
end
