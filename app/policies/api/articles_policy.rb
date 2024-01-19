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
    # Define the conditions for authorizing the user to add metadata
    user.has_role?(:editor) || user.has_role?(:admin)
  end
end
