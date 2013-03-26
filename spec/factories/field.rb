FactoryGirl.define do
  factory :field, :class => Noodall::Field do |field|
    field.name {Faker::Lorem.words(2).join(' ')}
  end
end


FactoryGirl.define do
  factory :text_field, :parent => :field, :class => Noodall::TextField do |field|
  end
end

FactoryGirl.define do
  factory :select_field, :parent => :field, :class => Noodall::Select do |field|
    field.options "One,Two,Three"
    field.default "Two"
  end
end

FactoryGirl.define do
  factory :radio_field, :parent => :select_field, :class => Noodall::Radio do |field|
    field.options "One,Two,Three"
  end
end

FactoryGirl.define do
  factory :check_box_field, :parent => :field, :class => Noodall::CheckBox do |field|
  end
end

FactoryGirl.define do
  factory :date_field, :parent => :field, :class => Noodall::DateField do |field|
  end
end
