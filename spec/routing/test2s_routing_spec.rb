require "rails_helper"

RSpec.describe Test2sController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/test2s").to route_to("test2s#index")
    end

    it "routes to #new" do
      expect(get: "/test2s/new").to route_to("test2s#new")
    end

    it "routes to #show" do
      expect(get: "/test2s/1").to route_to("test2s#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/test2s/1/edit").to route_to("test2s#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/test2s").to route_to("test2s#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/test2s/1").to route_to("test2s#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/test2s/1").to route_to("test2s#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/test2s/1").to route_to("test2s#destroy", id: "1")
    end
  end
end
