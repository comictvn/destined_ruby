class MatchSerializer < ActiveModel::Serializer
  attributes :id, :team1, :team2, :date, :result
end
