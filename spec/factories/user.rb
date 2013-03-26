FactoryGirl.define do
  factory :user do |user|
    user.email                 { |u| Faker::Internet.email(u.name) }
    user.name                  { Faker::Name.name }
    user.password              { "password" }
    user.password_confirmation { "password" }
  end
end

FactoryGirl.define do
  factory :website_editor, :parent => :user do |user|
    user.groups [ "editor" ]
  end
end

FactoryGirl.define do
  factory :website_administrator, :parent => :user do |user|
    user.groups [ "admin" ]
  end
end

