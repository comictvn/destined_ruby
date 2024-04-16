
# typed: true
class ColorStyleCreationService
  attr_reader :name, :color_code, :design_file_id

  def initialize(name:, color_code:, design_file_id:)
    @name = name
    @color_code = color_code
    @design_file_id = design_file_id
  end

  def call
    validate_parameters
    design_file = find_design_file(design_file_id)
    check_user_access(design_file)
    color_style = create_color_style(design_file)
    handle_group_association(color_style)
    color_style
  end

  private
  
  def validate_parameters
    raise Exceptions::InvalidColorStyleInputError, I18n.t('activerecord.errors.models.color_style.attributes.name.blank') if name.blank?
    raise Exceptions::InvalidColorStyleInputError, I18n.t('activerecord.errors.models.color_style.attributes.color_code.blank') if color_code.blank?
    raise Exceptions::InvalidColorStyleInputError, I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid_format') unless color_code.match(/\A#(?:[0-9a-fA-F]{3}){1,2}\z/)
    raise Exceptions::InvalidColorStyleInputError, I18n.t('activerecord.errors.models.color_style.attributes.design_file_id.blank') if design_file_id.blank?
  end

  def find_design_file(design_file_id)
    DesignFile.find(design_file_id)
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::DesignFileNotFoundError, I18n.t('activerecord.errors.models.design_file.not_found')
  end

  def check_user_access(design_file)
    # Assuming we have a method `user_has_access_to_design_file?` to check access
    raise Exceptions::AccessDeniedError, I18n.t('activerecord.errors.models.design_file.access_denied') unless user_has_access_to_design_file?(design_file)
  end

  def create_color_style(design_file)
    color_style = design_file.color_styles.new(name: name, color_code: color_code)
    raise Exceptions::InvalidColorStyleInputError, color_style.errors.full_messages.to_sentence unless color_style.save
    color_style
  end

  def handle_group_association(color_style)
    # Assuming we have a method `associate_with_group` to handle group association
    associate_with_group(color_style) if name_indicates_group?
  end

  def name_indicates_group?
    # Placeholder for checking if the name follows a specific naming convention indicating a group
  end
  
  def associate_with_group(color_style)
    # Placeholder for the logic to update or create the group association
  end

  def user_has_access_to_design_file?(design_file)
    # Placeholder for the logic to check if the user has the necessary access level to modify the design file
  end
  
end
