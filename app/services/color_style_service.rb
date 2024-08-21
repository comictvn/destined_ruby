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
        # Here you would implement the logic to update the color value within the design file.
        # This is a placeholder for the actual implementation, which would depend on how
        # the color values are stored and used within the design files.
        # For example, if design files have a method to update colors, it could look like this:
        # design_file.update_color(color_style.name, new_color)
      end
    rescue => e
      # Log the error
      logger.error "Error propagating color style update: #{e.message}"
      raise e
    end
  end
end