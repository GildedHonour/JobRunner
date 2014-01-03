FactoryGirl.define do
  factory :company do
    name { Faker::Company.name }
  end

  factory :contact do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end

  factory :user do
    email { Faker::Internet.email }
    password "password"
  end
end