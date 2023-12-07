class Api::TablesController < ApplicationController
  def create
    name = params.require(:name)
    if name.blank?
      render json: { errors: 'The table name is required.' }, status: :unprocessable_entity
    elsif name.length > 50
      render json: { errors: 'You cannot input more 50 characters.' }, status: :unprocessable_entity
    else
      begin
        table = TableService::Create.new(name).execute
        render json: { status: 200, table: table }, status: :ok
      rescue => e
        render json: { errors: e.message }, status: :internal_server_error
      end
    end
  end
end
