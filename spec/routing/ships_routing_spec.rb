require "rails_helper"

RSpec.describe ShipsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/ships").to route_to("ships#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/ships/new").to route_to("ships#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/ships/1").to route_to("ships#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/ships/1/edit").to route_to("ships#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/ships").to route_to("ships#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/ships/1").to route_to("ships#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/ships/1").to route_to("ships#destroy", :id => "1")
    end

  end
end
