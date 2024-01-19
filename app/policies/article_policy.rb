
class ArticlePolicy
  attr_reader :user, :record

  def update?
    # Assuming 'user' is the current user and 'record' is the article being accessed
    user.admin? || record.user_id == user.id
  end

  # ... other methods ...
end
