require 'rails_helper'

RSpec.describe "ships/edit", type: :view do
  before(:each) do
    @ship = assign(:ship, Ship.create!(
      :name => "MyString",
      :mmsi => 1
    ))
  end

  it "renders the edit ship form" do
    render

    assert_select "form[action=?][method=?]", ship_path(@ship), "post" do

      assert_select "input#ship_name[name=?]", "ship[name]"

      assert_select "input#ship_mmsi[name=?]", "ship[mmsi]"
    end
  end
end
