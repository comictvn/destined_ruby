# typed: true
class ColorStyleService < BaseService
  def initialize(*_args)
    super
  end

  # Propagates the color style update to all associated design files
  def propagate_color_style_update(color_style, new_color)
    begin
      # Find all design files associated with the same team as the color style
      design_files = DesignFile.where(team_id: color_style.team_id)
      
      # Iterate over each design file and update the color value
      design_files.each do |design_file|
        # Update the color value within the design file
        # Assuming that the design files have a column named 'color_value' that stores the color styles
        # and that the color styles are uniquely named, we can directly update the color_value.
        if design_file.color_value == color_style.color_value
          design_file.update(color_value: new_color)
        end
      end
    rescue => e
      # Log the error
      logger.error "Error propagating color style update: #{e.message}"
      raise e
    end
  end
end