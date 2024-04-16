
# typed: true
class ColorStyleCreationService
  attr_reader :name, :color_code, :design_file_id

  def initialize(name:, color_code:, design_file_id:)
    @name = name
    @color_code = color_code
    @design_file_id = design_file_id
  end

  def call
    validate_input_parameters
    design_file = find_design_file
    check_user_access(design_file)
    color_style = create_color_style(design_file)
    handle_group_association(color_style)
    { group_id: color_style.layer_id, color_style_ids: design_file.color_styles.where(layer_id: color_style.layer_id).pluck(:id) }
  end

  private
  
  def validate_input_parameters
    raise Exceptions::ColorStyleInvalidInputError.new(I18n.t('activerecord.errors.models.color_style.attributes.name.blank')) if name.blank?
    raise Exceptions::ColorStyleInvalidInputError.new(I18n.t('activerecord.errors.models.color_style.attributes.color_code.blank')) if color_code.blank?
    raise Exceptions::ColorStyleInvalidInputError.new(I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid_format')) unless color_code.match(/\A#(?:[0-9a-fA-F]{3}){1,2}\z/)
    raise Exceptions::ColorStyleInvalidInputError.new(I18n.t('activerecord.errors.models.color_style.attributes.design_file_id.blank')) if design_file_id.blank?
  end

  # Additional validation for group naming convention
  def group_naming_convention
    errors.add(:name, I18n.t('activerecord.errors.models.color_style.attributes.name.invalid_group_naming')) unless name.include?('/')
  end

  def find_design_file
    DesignFile.find(design_file_id)
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::DesignFileNotFoundError.new(I18n.t('activerecord.errors.models.design_file.attributes.design_file_id.not_found'))
  end

  def check_user_access(design_file)
    # Assuming we have a method `user_has_access_to_design_file?` to check access
    raise Exceptions::AccessDeniedError.new(I18n.t('activerecord.errors.models.design_file.access_denied')) unless user_has_access_to_design_file?(design_file)
  end

  def create_color_style(design_file)
    color_style = design_file.color_styles.new(name: extract_style_name, color_code: color_code)
    raise Exceptions::ColorStyleInvalidInputError.new(color_style.errors.full_messages.to_sentence) unless color_style.save

    color_style
  end

  def handle_group_association(color_style)
    associate_with_group(color_style) if group_name_present?
  end

  def group_name_present?
    name.include?('/')
  end

  def associate_with_group(color_style)
    group = find_or_create_group
    color_style.update!(name: extract_style_name, layer_id: group.id)
  end

  def find_or_create_group
    group_name = extract_group_name
    ColorStyle.find_or_create_by!(name: group_name, design_file_id: design_file_id)
  end

  def extract_group_name
    name.split('/', 2).first
  end

  def extract_style_name
    name.split('/', 2).last
  end

  def user_has_access_to_design_file?(design_file)
    # Placeholder for the logic to check if the user has the necessary access level to modify the design file
  end
end
