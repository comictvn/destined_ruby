require 'swagger_helper'

RSpec.describe 'ForceUpdateAppVersion', type: :request do
  path '/api/force_update_app_versions' do
    get 'List force_update_app_versions' do
      tags 'force_update_app_versions'
      consumes 'application/json'
      security [bearerAuth: []]

      parameter name: :params, in: :url, schema: {
        type: :object,
        properties: {

          force_update_app_versions: {
            type: :object,
            properties: {

              platform: {

                type: 'string',
                enum: %w[ios android]

              },

              reason: {

                type: :text

              },

              version: {

                type: :string

              },

              force_update: {

                type: :boolean

              }

            }
          },

          pagination_page: {

            type: :page_number

          },

          pagination_limit: {

            type: :page_size

          }

        }
      }
      response '200', 'filter' do
        examples 'application/json' => {

          'total_pages' => 'INTEGER',

          'force_update_app_versions' => 'ARRAY',

          'message' => {}

        }

        let(:resource) { create(:force_update_app_version) }
        let(:params) {}
        run_test! do |response|
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
