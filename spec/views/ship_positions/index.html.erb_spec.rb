require 'rails_helper'

RSpec.describe "ship_positions/index", type: :view do
  before(:each) do
    assign(:positions, [
      ShipPosition.create!(
        :mmsi => 1,
        :position => "",
        :speed => "",
        :course => "",
        :status => 2,
      ),
      ShipPosition.create!(
        :mmsi => 1,
        :position => "",
        :speed => "",
        :course => "",
        :status => 2,
      )
    ])
  end

  it "renders a list of ship_positions" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
