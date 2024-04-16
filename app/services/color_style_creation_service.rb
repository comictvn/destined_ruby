
class ColorStyleCreationService
  attr_reader :name, :color_code, :design_file_id

  def initialize(name, color_code, design_file_id)
    @name = name
    @color_code = color_code
    @design_file_id = design_file_id
  end

  def call
    validate_input_parameters
    design_file = find_design_file
    check_user_permission(design_file)
    color_style = create_color_style(design_file)
    handle_grouping(color_style)
    color_style
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::RecordNotFound, I18n.t('activerecord.errors.messages.record_not_found')
  rescue Exceptions::UnauthorizedAccess
    raise Exceptions::UnauthorizedAccess, I18n.t('common.errors.unauthorized_error')
  end

  private

  def validate_input_parameters
    raise Exceptions::BadRequest, I18n.t('activerecord.errors.messages.invalid') if name.blank? || color_code.blank?
  end

  def find_design_file
    DesignFile.find(design_file_id)
  end

  def check_user_permission(design_file)
    # Placeholder for user permission check logic
    # raise Exceptions::UnauthorizedAccess unless user_has_permission_to_modify_design_file?(design_file)
  end

  def create_color_style(design_file)
    design_file.color_styles.create!(name: name, color_code: color_code)
  end

  def handle_grouping(color_style)
    # Placeholder for specific naming convention for grouping logic
    # update_or_create_group_association_if_needed(color_style)
  end
end
