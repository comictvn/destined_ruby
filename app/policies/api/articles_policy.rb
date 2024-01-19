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

  def add_metadata?
    user.has_role?(:editor) || user.has_role?(:admin)
  end

  def update?
    user.admin? || article.user_id == user.id
  end
end
