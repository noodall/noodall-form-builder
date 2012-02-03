require 'spec_helper'

describe Noodall::FormResponse do

  it "should have methods based on it's forms fields" do
    form = Factory(:form)
    r = form.responses.build
    test_date = Time.now
    r.date = test_date
    r.date.should == test_date.to_date
  end

  it "should validate fields marked required in it's form" do
    form = Factory(:form)
    r = form.responses.build()
    r.save
    r.errors.messages.should have_key(:date)
  end

  it "should not persist feilds in the class" do
    form = Factory(:form)
    r1 = form.responses.build
    r1.save
    r1.errors.messages.should have_key(:date)

    form = Factory(:blank_form)
    r = form.responses.build
    r.save
    r.errors.messages.should_not have_key(:date)

    r1.save
    r1.errors.messages.should have_key(:date)
  end
end
