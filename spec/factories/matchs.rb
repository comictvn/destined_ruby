FactoryBot.define do
  factory :match do
    user { create(:user) }

    user { create(:user) }
  end
end
