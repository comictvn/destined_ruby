# typed: true
class DesignFiles::UndoTextLayerStyleService < BaseService
  def initialize(design_id, text_layer_id)
    @design_id = design_id
    @text_layer_id = text_layer_id
  end

  def call
    DesignFile.transaction do
      design_file = DesignFile.find_by(id: @design_id)
      text_layer = TextLayer.find_by(id: @text_layer_id, design_file: design_file)

      raise StandardError.new("Design file not found") unless design_file
      raise StandardError.new("Text layer not found") unless text_layer

      previous_style = text_layer.text_style.previous_version
      raise StandardError.new("Previous text style version not found") unless previous_style

      text_layer.update!(
        font_family: previous_style.font_family,
        font_style: previous_style.font_style,
        font_size: previous_style.font_size,
        line_height: previous_style.line_height,
        letter_spacing: previous_style.letter_spacing,
        paragraph_alignment: previous_style.paragraph_alignment,
        text_transform: previous_style.text_transform,
        text_color: previous_style.text_color,
        opacity: previous_style.opacity,
        text_transformation: previous_style.text_transformation
      )

      design_file.update!(last_modified: Time.current)

      { success: true, message: "Text styles reverted successfully" }
    end
  rescue => e
    logger.error "UndoTextLayerStyleService Error: #{e.message}"
    { success: false, message: e.message }
  end
end