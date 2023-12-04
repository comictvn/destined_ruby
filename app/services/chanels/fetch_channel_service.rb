module Chanels
  class FetchChannelService
    def initialize(id)
      @id = id
    end
    def call
      validate_params
      begin
        chanel = Chanel.find_by(id: @id)
        raise 'Chanel not found' unless chanel
        prepare_response(chanel)
      rescue StandardError => e
        raise e.message
      end
    end
    private
    def validate_params
      raise 'Invalid id format' unless @id.is_a?(Integer)
    end
    def prepare_response(chanel)
      {
        id: chanel.id,
        name: chanel.name,
        description: chanel.description,
        created_at: chanel.created_at,
        updated_at: chanel.updated_at
      }
    end
  end
end
