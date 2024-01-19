# typed: true
# frozen_string_literal: true

class ArticlePolicy < ApplicationPolicy
  attr_reader :user, :record, :article

  def initialize(user, record)
    @user = user
    @record = record
    @article = record # Assuming that record is the article we are dealing with
  end

  def publish?
    user.admin? || record.user_id == user.id
  end

  def update?
    user.admin? || record.user_id == user.id
  end

  def edit?
    # The edit? method should ensure that the article is published and the user is the author or an admin
    record.published? && (user.admin? || record.user_id == user.id)
  end

  def destroy?
    user.admin? || record.user_id == user.id
  end

  # ... other methods from the existing code should be included here ...
end
