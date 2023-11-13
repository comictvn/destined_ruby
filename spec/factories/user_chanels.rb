FactoryBot.define do
  factory :user_chanel do
    user { create(:user) }

    chanel { create(:chanel) }
  end
end
