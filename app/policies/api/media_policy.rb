class Api::MediaPolicy
  attr_reader :user, :media

  def initialize(user, media)
    @user = user
    @media = media
  end

  def create?
    true
  end
end
