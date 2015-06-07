require 'rails_helper'

RSpec.describe "ships/new", type: :view do
  before(:each) do
    assign(:ship, Ship.new(
      :name => "MyString",
      :mmsi => 1
    ))
  end

  it "renders new ship form" do
    render

    assert_select "form[action=?][method=?]", ships_path, "post" do

      assert_select "input#ship_name[name=?]", "ship[name]"

      assert_select "input#ship_mmsi[name=?]", "ship[mmsi]"
    end
  end
end
