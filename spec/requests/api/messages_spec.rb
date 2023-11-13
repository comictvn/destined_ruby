require 'swagger_helper'

RSpec.describe 'Message', type: :request do
  path '/api/messages' do
    post 'Create messages' do
      tags 'messages'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {

          messages: {
            type: :object,
            properties: {

              content: {

                type: :text

              },

              sender_id: {

                type: :integer

              },

              chanel_id: {

                type: :integer

              },

              images: {

                type: :file

              }

            }
          }

        }
      }
      response '200', 'create' do
        examples 'application/json' => {

          'message' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'sender' => {

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

            'sender_id' => 'INTEGER',

            'chanel' => {

              'id' => 'INTEGER',

              'created_at' => 'DATETIME',

              'updated_at' => 'DATETIME'

            },

            'chanel_id' => 'INTEGER',

            'content' => 'TEXT',

            'images' => 'FILE'

          },

          'error_object' => {}

        }

        let(:resource) { build(:message) }

        let(:params) { { messages: resource.attributes.to_hash } }

        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
