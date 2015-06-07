require 'rails_helper'

RSpec.describe "ship_positions/show", type: :view do
  before(:each) do
    @ship = assign(:ship, create(:ship))
    @positions = assign(:positions, [
      create(:ship_position, mmsi: @ship.mmsi,)
    ])
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
