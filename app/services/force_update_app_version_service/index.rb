# rubocop:disable Layout/LineLength
# rubocop:disable Style/ClassAndModuleChildren
class ForceUpdateAppVersionService::Index
  attr_accessor :records
  def initialize
    @records = ForceUpdateAppVersion.all
  end
  def execute
    order
    paginate
  end
  def order
    return if records.blank?
    @records = records.order('force_update_app_versions.created_at desc')
  end
  def paginate
    @records = ForceUpdateAppVersion.none if records.blank?
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Style/ClassAndModuleChildren
