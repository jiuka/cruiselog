require 'rails_helper'

RSpec.describe "Cruises", type: :request do
  describe "GET /cruises" do
    it "works! (now write some real specs)" do
      get cruises_path
      expect(response).to have_http_status(200)
    end
  end
end
