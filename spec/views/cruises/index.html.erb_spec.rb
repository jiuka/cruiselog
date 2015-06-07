require 'rails_helper'

RSpec.describe "cruises/index", type: :view do
  before(:each) do
    assign(:cruises, [
      create(:cruise),
      create(:cruise)
    ])
  end

  it "renders a list of cruises" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
