# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization

  attr_accessor :params, :records, :query

  def initialize(params, current_user = nil)
    @params = params

    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
  end

  def execute
    phone_number_start_with

    firstname_start_with

    lastname_start_with

    dob_equal

    gender_equal

    interests_start_with

    location_start_with

    email_start_with

    order

    paginate
  end

  def phone_number_start_with
    return if params.dig(:users, :phone_number).blank?

    @records = User.where('phone_number like ?', "%#{params.dig(:users, :phone_number)}")
  end

  def firstname_start_with
    return if params.dig(:users, :firstname).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('firstname like ?', "%#{params.dig(:users, :firstname)}"))
               end
  end

  def lastname_start_with
    return if params.dig(:users, :lastname).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('lastname like ?', "%#{params.dig(:users, :lastname)}"))
               end
  end

  def dob_equal
    return if params.dig(:users, :dob).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('dob = ?', params.dig(:users, :dob)))
               end
  end

  def gender_equal
    return if params.dig(:users, :gender).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('gender = ?', params.dig(:users, :gender)))
               end
  end

  def interests_start_with
    return if params.dig(:users, :interests).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('interests like ?', "%#{params.dig(:users, :interests)}"))
               end
  end

  def location_start_with
    return if params.dig(:users, :location).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('location like ?', "%#{params.dig(:users, :location)}"))
               end
  end

  def email_start_with
    return if params.dig(:users, :email).blank?

    @records = if records.is_a?(Class)
                 User.where(value.query)
               else
                 records.or(User.where('email like ?', "%#{params.dig(:users, :email)}"))
               end
  end

  def order
    return if records.blank?

    @records = records.order('users.created_at desc')
  end

  def paginate
    @records = User.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end

  def upload_profile_photo(userId, photo)
    user = User.find_by(id: userId)
    raise ActiveRecord::RecordNotFound, 'User not found' unless user

    raise ActiveRecord::RecordInvalid, 'Invalid photo format' unless ['image/jpeg', 'image/png'].include?(photo.content_type)
    raise ActiveRecord::RecordInvalid, 'Photo exceeds maximum size limit' if photo.size > 5.megabytes

    blob = ActiveStorageBlob.create!(
      filename: photo.original_filename,
      content_type: photo.content_type,
      byte_size: photo.size,
      checksum: photo.checksum
    )

    attachment = ActiveStorageAttachment.create!(
      name: 'profile_photo',
      record_type: 'User',
      record_id: user.id,
      blob_id: blob.id
    )

    user.update!(profile_photo_id: attachment.id)

    attachment
  rescue ActiveRecord::RecordInvalid => e
    raise e
  rescue ActiveRecord::RecordNotFound => e
    raise e
  end
end
# rubocop:enable Style/ClassAndModuleChildren