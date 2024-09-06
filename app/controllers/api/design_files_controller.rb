# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :set_design_file, only: [:undo_text_layer_style_changes]
    before_action :set_text_layer, only: [:undo_text_layer_style_changes]

    def undo_text_layer_style_changes
      previous_style = retrieve_previous_style(@text_layer)
      if previous_style
        @text_layer.update(previous_style)
        @design_file.touch(:last_modified)
        render_response({ message: "Text styles reverted successfully" })
      else
        render_error("Previous style not found", status: :not_found)
      end
    rescue StandardError => e
      render_error(e.message, status: :internal_server_error)
    end

    private

    def set_design_file
      @design_file = DesignFile.find(params[:design_id])
    end

    def set_text_layer
      @text_layer = @design_file.text_layers.find(params[:text_layer_id])
    end

    def retrieve_previous_style(text_layer)
      # This method should interact with the history log or version control system.
      # The implementation details are not provided, so this is a placeholder.
      # Replace with actual retrieval logic.
      {
        font_family: "PreviousFontFamily",
        font_style: "PreviousFontStyle",
        font_size: 12,
        line_height: "PreviousLineHeight",
        letter_spacing: "PreviousLetterSpacing",
        paragraph_alignment: "left",
        text_transform: "none",
        text_color: "#000000",
        opacity: 100
      }
    end
  end
end