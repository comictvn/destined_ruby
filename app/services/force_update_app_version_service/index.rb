# rubocop:disable Layout/LineLength
class ForceUpdateAppVersionService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = ForceUpdateAppVersion
  end

  def execute
    platform_equal
    reason_start_with
    version_start_with
    force_update_equal
    order
    paginate
  end

  def create
    existing_record = ForceUpdateAppVersion.find_by(platform: params[:platform], version: params[:version])
    raise Exceptions::BadRequest, 'Record already exists' if existing_record

    force_update_app_version = ForceUpdateAppVersion.new(params)
    if force_update_app_version.save
      force_update_app_version
    else
      raise Exceptions::UnprocessableEntity, force_update_app_version.errors.full_messages.to_sentence
    end
  rescue ActiveRecord::RecordInvalid => e
    raise Exceptions::UnprocessableEntity, e.record.errors.full_messages.to_sentence
  rescue ActiveRecord::RecordNotUnique
    raise Exceptions::BadRequest, 'Record already exists with the same platform and version'
  end

  def platform_equal
    return if params.dig(:force_update_app_versions, :platform).blank?

    @records = ForceUpdateAppVersion.where('platform = ?', params.dig(:force_update_app_versions, :platform))
  end

  def reason_start_with
    return if params.dig(:force_update_app_versions, :reason).blank?

    @records = if records.is_a?(Class)
                 ForceUpdateAppVersion.where(value.query)
               else
                 records.or(ForceUpdateAppVersion.where('reason like ?', "%#{params.dig(:force_update_app_versions, :reason)}"))
               end
  end

  def version_start_with
    return if params.dig(:force_update_app_versions, :version).blank?

    @records = if records.is_a?(Class)
                 ForceUpdateAppVersion.where(value.query)
               else
                 records.or(ForceUpdateAppVersion.where('version like ?', "%#{params.dig(:force_update_app_versions, :version)}"))
               end
  end

  def force_update_equal
    return if params.dig(:force_update_app_versions, :force_update).blank?

    @records = if records.is_a?(Class)
                 ForceUpdateAppVersion.where(value.query)
               else
                 records.or(ForceUpdateAppVersion.where('force_update = ?', params.dig(:force_update_app_versions, :force_update)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('force_update_app_versions.created_at desc')
  end

  def paginate
    @records = ForceUpdateAppVersion.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Layout/LineLength
# rubocop:disable Style/ClassAndModuleChildren
