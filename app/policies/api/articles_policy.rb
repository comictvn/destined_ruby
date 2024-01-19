# typed: true
# frozen_string_literal: true

class ArticlesPolicy < ApplicationPolicy
  def create_draft?
    true
  end
end
