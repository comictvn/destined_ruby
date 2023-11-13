require 'rails_helper'
RSpec.describe "Users", type: :request do
  let(:user) { create(:user) }
  let(:valid_attributes) do
    {
      email: 'test@example.com',
      platform: 'facebook'
    }
  end
  let(:invalid_attributes) do
    {
      email: '',
      platform: ''
    }
  end
  describe "POST /social_login" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post '/api/users/social_login', params: valid_attributes
        }.to change(User, :count).by(1)
      end
      it "renders a successful response" do
        post '/api/users/social_login', params: valid_attributes
        expect(response).to be_successful
        expect(response.body).to include("Registration/Login successful.")
      end
    end
    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post '/api/users/social_login', params: invalid_attributes
        }.to change(User, :count).by(0)
      end
      it "renders an unsuccessful response" do
        post '/api/users/social_login', params: invalid_attributes
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("The platform is required.")
        expect(response.body).to include("The email is required.")
      end
    end
  end
end
