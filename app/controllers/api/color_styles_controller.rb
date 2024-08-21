# typed: true
module Api
  class ColorStylesController < BaseController
    # PATCH/PUT /api/color_styles/:styleId
    def update_color_style
      color_style = ColorStyle.find_by(id: params[:styleId])
      
      if color_style.nil?
        base_render_record_not_found
        return
      end
      
      new_color = params[:newColor]
      if new_color.match(/\A#(?:[0-9a-fA-F]{3}){1,2}\z/)
        color_style.update!(color_value: new_color)
        ColorStyleService.new.propagate_color_style_update(color_style, new_color)
        render_response({ message: I18n.t('controller.color_style.update.success') })
      else
        raise Exceptions::BadRequest.new(I18n.t('validation.invalid', attribute: 'Color'))
      end
    rescue Exceptions::BadRequest => e
      render_error('bad_request', message: e.message, status: :bad_request)
    rescue ActiveRecord::RecordInvalid => e
      render_error('unprocessable_entity', message: e.record.errors.full_messages, status: :unprocessable_entity)
    end
  end
end