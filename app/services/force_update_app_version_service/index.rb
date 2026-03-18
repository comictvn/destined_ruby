
# rubocop:disable Layout/LineLength
# rubocop:disable Style/ClassAndModuleChildren
class ForceUpdateAppVersionService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = ForceUpdateAppVersion.all
  end

  def execute
    platform_equal
    reason_start_with
    version_start_with
    force_update_equal
    order
    paginate
  end

  def platform_equal
    return if params.dig(:force_update_app_versions, :platform).blank?

    @records = records.where(platform: params.dig(:force_update_app_versions, :platform))
  end

  def reason_start_with
    return if params.dig(:force_update_app_versions, :reason).blank?

    @records = records.where('reason LIKE ?', "%#{params.dig(:force_update_app_versions, :reason)}%")
  end

  def version_start_with
    return if params.dig(:force_update_app_versions, :version).blank?

    @records = records.where('version LIKE ?', "%#{params.dig(:force_update_app_versions, :version)}%")
  end

  def force_update_equal
    return if params.dig(:force_update_app_versions, :force_update).blank?

    @records = records.where(force_update: params.dig(:force_update_app_versions, :force_update))
  end

  def order
    return if records.none?

    @records = records.order(created_at: :desc)
  end

  def paginate
    @records = records.page(params[:page] || 1).per(params[:per_page] || 20)
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Style/ClassAndModuleChildren
