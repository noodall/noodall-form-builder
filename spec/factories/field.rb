Factory.define :field, :class => Noodall::Field do |field|
  field.name {Faker::Lorem.words(2).join(' ')}
end


Factory.define :text_field, :parent => :field, :class => Noodall::TextField do |field|
end
Factory.define :select_field, :parent => :field, :class => Noodall::Select do |field|
  field.options "One,Two,Three"
  field.default "Two"
end
Factory.define :radio_field, :parent => :select_field, :class => Noodall::Radio do |field|
end
Factory.define :check_box_field, :parent => :field, :class => Noodall::CheckBox do |field|
end
