
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

  private

  def validate_parameters
    raise ArgumentError, 'Name cannot be blank' if name.blank?
    raise ArgumentError, 'Color code cannot be blank' if color_code.blank?
    raise ArgumentError, 'Design file ID cannot be blank' if design_file_id.blank?
  end

  def find_design_file
    DesignFile.find(design_file_id)
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::DesignFileNotFoundError
  end

  def check_user_access(design_file)
    # Placeholder for user access level check
  end

  def create_color_style(design_file)
    design_file.color_styles.create!(name: name, color_code: color_code)
  end

  def handle_group_association(color_style)
    group_name = extract_group_name(color_style.name)
    layer = Layer.find_or_create_by(name: group_name, design_file_id: design_file_id)
    color_style.layer = layer
    color_style
  end

  def extract_group_name(name)
    # Logic to extract group name from the "name" attribute
  end
end
