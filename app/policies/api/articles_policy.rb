# typed: true
# frozen_string_literal: true

class ArticlesPolicy < ApplicationPolicy
  attr_reader :user, :article

  def initialize(user, article)
    @user = user
    @article = article
  end

  def create_draft?
    true
  end

  # The add_metadata? method should allow both the author of the article
  # and users with editor or admin roles to add metadata.
  def add_metadata?
    user.has_role?(:editor) || user.has_role?(:admin) || article.user_id == user.id
  end

  def update?
    user.admin? || article.user_id == user.id
  end
end
