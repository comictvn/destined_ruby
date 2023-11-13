FactoryBot.define do
  factory :user do
    password { Faker::Internet.password(min_length: 13, max_length: 20, mix_case: true, special_characters: true) }

    phone_number { Faker::PhoneNumber.unique.cell_phone_in_e164[0..11] }

    thumbnail { Rack::Test::UploadedFile.new('spec/fixtures/assets/image.png', 'image/png') }

    firstname { Faker::Lorem.paragraph_by_chars(number: 255) }

    lastname { Faker::Lorem.paragraph_by_chars(number: 255) }

    dob { Date.current - 2 }

    gender { User.genders.keys[0] }

    interests { Faker::Lorem.paragraph_by_chars(number: 10) }

    location { Faker::Lorem.paragraph_by_chars(number: 10) }

    email { Faker::Internet.unique.email }
  end
end
