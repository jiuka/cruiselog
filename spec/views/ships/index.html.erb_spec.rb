require 'rails_helper'

RSpec.describe "ships/index", type: :view do
  before(:each) do
    assign(:ships, [
      Ship.create!(
        :name => "Name",
        :mmsi => 1
      ),
      Ship.create!(
        :name => "Name",
        :mmsi => 1
      )
    ])
  end

  it "renders a list of ships" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
