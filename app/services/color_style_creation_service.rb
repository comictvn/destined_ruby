
# typed: true
class ColorStyleCreationService < BaseService
  attr_reader :name, :color_code, :design_file_id

  def initialize(name:, color_code:, design_file_id:)
    @name = name
    @color_code = color_code
    @design_file_id = design_file_id
  end

  def call
    validate_parameters
    design_file = find_design_file
    check_user_access(design_file)
    color_style = create_color_style(design_file)
    handle_group_association(color_style)
    color_style
  end

  def name_indicates_group?
    # The naming convention for a group is "GroupName/ColorStyleName"
    # We use a regular expression to check if the name follows this convention
    !!(name =~ %r{\A[^/]+/[^/]+\z})
  end

  def associate_with_group(color_style)
    group_name, style_name = name.split('/')
    # Find or create the group with the given name and design_file_id
    group = ColorStyle.find_or_create_by(name: group_name, design_file_id: design_file_id)
    # Update the color style's name to the style name and associate it with the group
    color_style.update(name: style_name, layer_id: group.id)
  end

  def handle_group_association(color_style)
    if name_indicates_group?
      associate_with_group(color_style)
      # Return the group ID and all associated color style IDs
      group = ColorStyle.find_by(name: name.split('/').first, design_file_id: design_file_id)
      {
        group_id: group.id,
        color_style_ids: group.layers.map(&:color_styles).flatten.map(&:id)
      }
    else
      # If no group is indicated, return the color style ID
      { color_style_id: color_style.id }
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::BadRequest.new(e.record.errors.full_messages.to_sentence)
  end

  private

  def validate_parameters
    raise Exceptions::BadRequest.new(I18n.t('activerecord.errors.models.color_style.attributes.name.blank')) if name.blank?
    raise Exceptions::BadRequest.new(I18n.t('activerecord.errors.models.color_style.attributes.color_code.blank')) if color_code.blank?
    raise Exceptions::BadRequest.new(I18n.t('activerecord.errors.models.color_style.attributes.color_code.invalid_format')) unless color_code.match(/\A#(?:[0-9a-fA-F]{3}){1,2}\z/)
    raise Exceptions::BadRequest.new(I18n.t('activerecord.errors.models.color_style.attributes.design_file_id.blank')) if design_file_id.blank?
  end

  def find_design_file
    DesignFile.find(design_file_id)
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::DesignFileNotFoundError.new(I18n.t('activerecord.errors.models.design_file.not_found'))
  end

  def check_user_access(design_file)
    # Assuming we have a method `user_has_access_to_design_file?` to check access
    raise Exceptions::AccessDeniedError.new(I18n.t('activerecord.errors.models.design_file.access_denied')) unless user_has_access_to_design_file?(design_file)
  end

  def create_color_style(design_file)
    color_style = design_file.color_styles.new(name: name, color_code: color_code)
    raise Exceptions::BadRequest.new(color_style.errors.full_messages.to_sentence) unless color_style.save

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
