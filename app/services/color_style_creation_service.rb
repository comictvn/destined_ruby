
class ColorStyleCreationService
  attr_reader :name, :color_code, :design_file_id, :user

  def initialize(name, color_code, design_file_id, user)
    @name = name
    @color_code = color_code
    @design_file_id = design_file_id
    @user = user
  end
  
  def call
    validate_input_parameters
    design_file = find_design_file
    check_user_permission(design_file, user)
    color_style = create_color_style(design_file)
    handle_grouping(color_style)
    color_style
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::BadRequest, e.record.errors.full_messages.to_sentence
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::RecordNotFound, I18n.t('activerecord.errors.messages.record_not_found')
  rescue Exceptions::UnauthorizedAccess
    raise Exceptions::UnauthorizedAccess, I18n.t('common.errors.unauthorized_error')
  end

  private
  
  def validate_input_parameters
    raise Exceptions::BadRequest, I18n.t('activerecord.errors.messages.invalid') unless valid_name? && valid_color_code?
  end

  def valid_name?
    name.present? && name.match(/\A[a-zA-Z0-9_ ]+\z/)
  end
  
  def valid_color_code?
    color_code.present? && color_code.match(/\A#(?:[0-9a-fA-F]{3}){1,2}\z/i)
  end
  
  def find_design_file
    DesignFile.find_by!(id: design_file_id)
  end
  
  def check_user_permission(design_file, user)
    raise Exceptions::UnauthorizedAccess unless user.can_edit?(design_file)
  end
  
  def create_color_style(design_file)
    color_style = design_file.color_styles.new(name: name, color_code: color_code)
    if color_style.valid?
      color_style.save!
      return color_style
    else
      raise Exceptions::BadRequest.new(color_style.errors.full_messages.to_sentence)
    end
  end
  
  def handle_grouping(color_style)
    if group_name = extract_group_name
      group = ColorGroup.find_or_create_by!(name: group_name)
      color_style.update!(color_group_id: group.id)
    end
  end

  # ... other private methods ...
  
  def extract_group_name
    match_data = name.match(/\A(?<group_name>[a-zA-Z0-9_]+):/)
    match_data[:group_name] if match_data
  end
end
