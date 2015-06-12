require "rails_helper"

RSpec.describe CruisesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "").to route_to("cruises#index")
    end

    it "routes to #new" do
      expect(:get => "/new").to route_to("cruises#new")
    end

    it "routes to #show" do
      expect(:get => "/1").to route_to("cruises#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/1/edit").to route_to("cruises#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "").to route_to("cruises#create")
    end

    it "routes to #update" do
      expect(:put => "/1").to route_to("cruises#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/1").to route_to("cruises#destroy", :id => "1")
    end

  end
end
