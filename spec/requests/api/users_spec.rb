require 'swagger_helper'

RSpec.describe 'User', type: :request do
  path '/api/users/{id}' do
    get 'Show users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

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

            'location' => 'TEXT',

            'matcher2_matchs' => 'ARRAY',

            'sender_messages' => 'ARRAY',

            'user_chanels' => 'ARRAY',

            'matcher1_matchs' => 'ARRAY',

            'email' => 'STRING',

            'reacter_reactions' => 'ARRAY',

            'reacted_reactions' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:user) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/users' do
    get 'List users' do
      tags 'users'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          pagination_page: {

            type: :page_number

          },

          pagination_limit: {

            type: :page_size

          },

          users: {
            type: :object,
            properties: {

              phone_number: {

                type: :string

              },

              firstname: {

                type: :string

              },

              lastname: {

                type: :string

              },

              dob: {

                type: :date

              },

              gender: {

                type: 'string',
                enum: %w[male female other]

              },

              interests: {

                type: :text

              },

              location: {

                type: :text

              },

              email: {

                type: :string

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'users' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:user) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
