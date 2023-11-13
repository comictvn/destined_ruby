require 'swagger_helper'

RSpec.describe 'User', type: :request do
  path '/v1/me' do
    get 'List users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {}
      }
      response '200', 'show' do
        examples 'application/json' => {

          'user' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'phone_number' => 'STRING',

            'thumbnail' => 'FILE',

            'firstname' => 'STRING',

            'lastname' => 'STRING',

            'dob' => 'DATE',

            'gender' => 'STRING',

            'interests' => 'TEXT',

            'location' => 'TEXT'

          },

          'message' => {}

        }

        let(:resource_owner) { create(:user) }
        let(:token) { create(:custom_access_token, resource_owner: resource_owner).token }
        let(:Authorization) { "Bearer #{token}" }

        let(:resource) { create(:user) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
