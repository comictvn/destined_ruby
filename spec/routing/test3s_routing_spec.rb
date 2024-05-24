require "rails_helper"

RSpec.describe Test3sController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/test3s").to route_to("test3s#index")
    end

    it "routes to #new" do
      expect(get: "/test3s/new").to route_to("test3s#new")
    end

    it "routes to #show" do
      expect(get: "/test3s/1").to route_to("test3s#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/test3s/1/edit").to route_to("test3s#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/test3s").to route_to("test3s#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/test3s/1").to route_to("test3s#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/test3s/1").to route_to("test3s#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/test3s/1").to route_to("test3s#destroy", id: "1")
    end
  end
end
