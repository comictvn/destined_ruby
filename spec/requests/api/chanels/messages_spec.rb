require 'swagger_helper'

RSpec.describe 'Message', type: :request do
  path '/api/chanels/{chanel_id}/messages/{id}' do
    delete 'Destroy messages' do
      tags 'messages'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'chanel_id', in: :path, type: :string, description: 'Url Params'

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'delete' do
        examples 'application/json' => {

          'message' => {}

        }

        let(:resource) { create(:message) }
        let(:chanel_id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/chanels/{chanel_id}/messages' do
    get 'List messages' do
      tags 'messages'
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

              }

            }
          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'messages' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:message) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
