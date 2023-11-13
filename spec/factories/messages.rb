FactoryBot.define do
  factory :message do
    user { create(:user) }

    chanel { create(:chanel) }

    content { Faker::Lorem.paragraph_by_chars(number: 65_535) }

    images { [Rack::Test::UploadedFile.new('spec/fixtures/assets/image.png', 'image/png')] }
  end
end
