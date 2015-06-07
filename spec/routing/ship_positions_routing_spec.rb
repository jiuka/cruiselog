require "rails_helper"

RSpec.describe ShipPositionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/ship_positions").to route_to("ship_positions#index")
    end

    it "routes to #show" do
      expect(:get => "/admin/ships/1/positions").to route_to("ship_positions#show", :ship_id => "1")
    end

  end
end
