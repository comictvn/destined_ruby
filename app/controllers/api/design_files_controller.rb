
# typed: ignore
module Api
  class DesignFilesController < BaseController
    before_action :authenticate_user!
    rescue_from Exceptions::LayerIneligibleError, with: :render_layer_ineligible_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_error

    def display_color_styles_icon
      # ... existing code ...
    end

-   def list_color_styles
-     fileId = params[:fileId]
-
-     begin
-       design_file = current_user.design_files.find(fileId)
-       color_styles = design_file.color_styles.select(:id, :name, :color_code)
-
-       render_response({ status: 200, colorStyles: color_styles })
-     rescue => e
-       render_error('server_error', message: I18n.t('common.errors.server_error'), status: :internal_server_error)
-     end
-   end
+   def list_color_styles
+     fileId = params[:fileId]
+
+     design_file = DesignFile.find_by(id: fileId)
+     if design_file.nil?
+       render_error('not_found', message: I18n.t('design_files.color_styles.not_found'), status: :not_found)
+     elsif !design_file.accessible_by?(current_user)
+       render_error('unauthorized', message: I18n.t('design_files.color_styles.unauthorized'), status: :unauthorized)
+     else
+       color_styles = design_file.color_styles.select(:id, :name, :color_code)
+       render_response({ status: 200, colorStyles: color_styles }, message: I18n.t('design_files.color_styles.success'))
+     end
+   end

    def apply_color_style_to_layer
      # ... existing code ...
    end

    private

    def render_layer_ineligible_error(exception)
      # ... existing code ...
    end

    def render_not_found_error(exception)
      # ... existing code ...
    end

    # Checks if the layer is eligible for color styles
    def check_layer_eligibility(layer)
      # ... existing code ...
    end
  end
end
