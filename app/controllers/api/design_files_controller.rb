# typed: strict
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:update_text_layer_styles]
    before_action :set_text_layer, only: [:update_text_layer_styles]

    def update_text_layer_styles
      if @text_layer.update(text_layer_params)
        @design_file.touch(:last_modified)
        render_response({ message: 'Text styles updated successfully' })
      else
        base_render_unprocessable_entity(@text_layer)
      end
    end

    private

    def set_design_file
      @design_file = DesignFile.find_by(id: params[:designId])
      base_render_record_not_found unless @design_file
    end

    def set_text_layer
      @text_layer = @design_file.text_layers.find_by(id: params[:textLayerId])
      base_render_record_not_found unless @text_layer
    end

    def text_layer_params
      params.require(:text_layer).permit(
        :font_family, :font_style, :font_size, :line_height,
        :letter_spacing, :paragraph_alignment, :text_transform,
        :text_color, :opacity
      )
    end
  end
end