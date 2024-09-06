class Api::DesignFilesController < ApplicationController
  # PATCH/PUT /api/design_files/:designId
  def update_last_modified
    design_file = DesignFile.find(params[:designId])
    design_file.update!(last_modified: Time.current)
    render json: { message: 'Design file saved successfully' }
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Design file not found' }, status: :not_found
  end
end