class Api::MediaPolicy
  attr_reader :user, :media

  def initialize(user, media)
    @user = user
    @media = media
  end

  def create?
    true
  end

  def insert?
    user.admin? || user.has_role?(:editor) || media.article.user_id == user.id
  end
end
