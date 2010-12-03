Factory.define :field do |field|
  field.name {Faker::Lorem.words(1).join()}
end


Factory.define :text_field, :parent => :field, :class => TextField do |field|
end
Factory.define :select_field, :parent => :field, :class => Select do |field|
  field.options "One,Two,Three"
  field.default "Two"
end
Factory.define :radio_field, :parent => :select_field, :class => Radio do |field|
end
Factory.define :check_box_field, :parent => :field, :class => CheckBox do |field|
end