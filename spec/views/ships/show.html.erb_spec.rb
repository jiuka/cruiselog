require 'rails_helper'

RSpec.describe "ships/show", type: :view do
  before(:each) do
    @ship = assign(:ship, Ship.create!(
      :name => "Name",
      :mmsi => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/1/)
  end
end
