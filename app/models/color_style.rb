
# typed: strict
class ColorStyle < ApplicationRecord
  belongs_to :design_file
  belongs_to :layer

  validates :name, presence: true
  validates :color_code, presence: true
  validates :design_file_id, presence: true
  validates :layer_id, presence: true

  # Class method to find or create a group based on name and design_file_id
  def self.find_or_create_group(name, design_file_id)
    group_name = parse_group_name(name)
    return [nil, []] unless group_name

    group = ColorStyle.where(name: group_name, design_file_id: design_file_id).first_or_create
    color_styles = group.color_styles.pluck(:id)

    [group.id, color_styles]
  end

  # Helper method to parse the group name from the given name
  def self.parse_group_name(name)
    # Assuming the group name is prefixed with 'Group/' in the name
    name.start_with?('Group/') ? name.split('/').last : nil
  end
end
