
# typed: true
class ForceUpdateAppVersionService::Index
  include ActiveModel::Validations
  include Pagy::Backend
  attr_accessor :params, :records, :query

  validates :platform, presence: true, inclusion: { in: ForceUpdateAppVersion.platforms.keys }, if: :validation_context?
  validates :force_update, inclusion: { in: [true, false], allow_nil: true }, if: :validation_context?
  validates :version, presence: true, if: :validation_context?
  validates :reason, length: { maximum: 500 }, if: :validation_context?

  def initialize(params, _current_user = nil)
    @params = params
    @records = ForceUpdateAppVersion
  end

  def call
    validate_input!
    filter_by_platform
    filter_by_reason
    filter_by_version
    filter_by_force_update_value
    sort_records
    paginate_records
  rescue ActiveRecord::RecordNotFound => e
    raise Exceptions::ForceUpdateAppVersionNotFound, e.message
  end

  private

  def validate_input!
    return if valid?

    raise Exceptions::InvalidParametersError, errors.full_messages.to_sentence
  end

  def filter_by_platform
    return unless params[:platform].in?(ForceUpdateAppVersion.platforms.keys)

    @records = @records.where(platform: params[:platform])
  end

  def filter_by_reason
    return unless params[:reason].present?

    @records = @records.where('reason ILIKE ?', "%#{params[:reason]}%")
  end

  def filter_by_version
    return unless params[:version].present?

    @records = @records.where('version LIKE ?', "%#{params[:version]}%")
  end

  def filter_by_force_update_value
    return unless params[:force_update].in?([true, false])

    @records = @records.where(force_update: params[:force_update])
  end

  def sort_records
    @records = @records.order(created_at: :desc)
  end

  def paginate_records
    @pagy, @records = pagy(@records, items: params[:per_page] || 20, page: params[:page] || 1)
  end

  def validation_context?
    params[:action] == 'validate'
  end
end
