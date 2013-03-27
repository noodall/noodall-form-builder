FactoryGirl.define do
  factory :form, :class => Noodall::Form do |form|
    form.title "A Form"
    form.email "hello@wearebeef.co.uk"

    form.fields do
      fields = [create(:text_field, :name => 'Name', :required => true), create(:text_field, :name => 'Email', :required => true)]
      5.times do
        fields << create(:text_field)
      end
      fields << create(:check_box_field, :name => 'Check' )
      fields << create(:select_field, :name => 'Select')
      fields << create(:radio_field, :name => 'Radio')
      fields << create(:date_field, :name => 'Date', :required => true)

      fields
    end
  end
end

FactoryGirl.define do
  factory :blank_form, :class => Noodall::Form do |form|
    form.title "A Form"
    form.email "hello@wearebeef.co.uk"
  end
end
