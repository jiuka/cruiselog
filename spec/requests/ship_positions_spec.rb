require 'rails_helper'

RSpec.describe "ShipPositions", type: :request do
  describe "GET /admin/ship_positions" do
    it "works! (now write some real specs)" do
      get ship_positions_path
      expect(response).to have_http_status(200)
    end
  end
end
