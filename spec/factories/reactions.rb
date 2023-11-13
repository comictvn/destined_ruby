FactoryBot.define do
  factory :reaction do
    user { create(:user) }

    user { create(:user) }

    react_type { Reaction.react_types.keys[0] }
  end
end
