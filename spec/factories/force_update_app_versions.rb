FactoryBot.define do
  factory :force_update_app_version do
    platform { ForceUpdateAppVersion.platforms.keys[0] }

    reason { Faker::Lorem.paragraph_by_chars(number: 65_535) }

    version { Faker::Lorem.paragraph_by_chars(number: 255) }

    force_update { false }
  end
end
