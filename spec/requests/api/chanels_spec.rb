require 'swagger_helper'

RSpec.describe 'Chanel', type: :request do
  path '/api/chanels/{id}' do
    delete 'Destroy chanels' do
      tags 'chanels'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'delete' do
        examples 'application/json' => {

          'message' => {}

        }

        let(:resource) { create(:chanel) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/chanels/{id}' do
    get 'Show chanels' do
      tags 'chanels'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: 'id', in: :path, type: :string, description: 'Url Params'

      response '200', 'show' do
        examples 'application/json' => {

          'chanel' => {

            'id' => 'INTEGER',

            'created_at' => 'DATETIME',

            'updated_at' => 'DATETIME',

            'messages' => 'ARRAY',

            'user_chanels' => 'ARRAY'

          },

          'message' => {}

        }

        let(:resource) { create(:chanel) }
        let(:id) { resource.id }
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end

  path '/api/chanels' do
    get 'List chanels' do
      tags 'chanels'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          pagination_limit: {

            type: :page_size

          },

          pagination_page: {

            type: :page_number

          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'message' => {},

          'total_pages' => 'INTEGER',

          'chanels' => 'ARRAY'

        }

        let(:resource) { create(:chanel) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
