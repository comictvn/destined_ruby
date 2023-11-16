class MatchValidator < ActiveModel::Validator
  class ValidationError < StandardError; end
  def validate(record)
    validate_team1(record)
    validate_team2(record)
    validate_date(record)
  end
  private
  def validate_team1(record)
    if record.team1.blank?
      record.errors.add(:team1, "Team1 can't be blank")
    end
  end
  def validate_team2(record)
    if record.team2.blank?
      record.errors.add(:team2, "Team2 can't be blank")
    end
  end
  def validate_date(record)
    if record.date.blank?
      record.errors.add(:date, "Date can't be blank")
    elsif !record.date.is_a?(Date)
      record.errors.add(:date, "Invalid date format.")
    end
  end
end
