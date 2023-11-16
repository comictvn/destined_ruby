class MatchResultValidator < ActiveModel::Validator
  def validate(record)
    unless record.result.in?(Match.results.keys)
      record.errors.add(:result, "is not a valid enum type")
    end
  end
end
