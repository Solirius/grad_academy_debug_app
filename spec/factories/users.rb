FactoryBot.define do
  password = Faker::Internet.password

  factory :user do
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { password }
    password_confirmation { password }
    language { 'en' }
  end
end
