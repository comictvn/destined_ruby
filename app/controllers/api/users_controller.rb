class Api::UsersController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show]

  def index
    # inside service params are checked and whiteisted
    @users = UserService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @users.total_pages
  end

  def show
    @user = User.find_by!('users.id = ?', params[:id])

    authorize @user, policy_class: Api::UsersPolicy
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  def upload_profile_photo
    user = User.find_by(id: params[:userId])
    unless user
      return render_error('User not found', status: :not_found)
    end

    photo = params[:photo]
    if photo.size > 5.megabytes || !['image/jpeg', 'image/png'].include?(photo.content_type)
      return render_error('Invalid photo format or size', status: :unprocessable_entity)
    end

    blob = ActiveStorageBlob.create!(
      filename: photo.original_filename,
      content_type: photo.content_type,
      byte_size: photo.size,
      checksum: photo.checksum
    )

    attachment = ActiveStorageAttachment.create!(name: 'profile_photo', record_type: 'User', record_id: user.id, blob_id: blob.id)
    user.update!(profile_photo_id: attachment.id)

    render_response({ message: 'Profile photo updated successfully' })
  end
end