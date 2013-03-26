require 'spec_helper'

describe Noodall::Download do
  it "must have a form id" do
    download = Noodall::Download.new
    download.valid?
    download.errors.to_a.should include("Form can't be blank")
  end

  it "must have a form title" do
    download = Noodall::Download.new
    download.valid?
    download.errors.to_a.should include("Form title can't be blank")
  end

  it "must have conditions" do
    download = Noodall::Download.new
    download.valid?
    download.errors.to_a.should include("Conditions can't be blank")
  end

  it "must have empty output" do
    download = Noodall::Download.new
    download.output.should be_nil
  end
  
  context 'with specific date conditions' do

    it "must have a filename attribute based on it's conditions" do
      conditions = { "day"=>"1", "month"=>"10", "year"=>"2011" }

      download = Noodall::Download.new(
        form_title: "A most excellent form",
        conditions: conditions,
        updated_at: "Thu, 16 Aug 2012 09:54:35 UTC +00:00"
      )

      download.filename.should == "A most excellent form responses 10-2011 2012-08-16 09:54:35.csv"
    end
  end
  # with specific date conditions
  
  context 'no date conditions (all responses returned)' do
    
    it "must have a filename attribute based on it's conditions" do
      conditions = { "month"=>"all", "year"=>"all" }

      download = Noodall::Download.new(
        form_title: "A most excellent form",
        conditions: conditions,
        updated_at: "Thu, 16 Aug 2012 09:54:35 UTC +00:00"
      )

      download.filename.should == "A most excellent form ALL responses 2012-08-16 09:54:35.csv"
    end
    
    
  end
  # no date conditions (all responses returned)
  

  it "must be flagged to email when ready" do
    download = Noodall::Download.new
    download.email_when_ready('test@example.com')
    download.email.should == 'test@example.com'
  end

  describe "#email_when_ready?" do
    it "must be false if an email is NOT available" do
      download = Noodall::Download.new
      download.email_when_ready?.should be_false
    end

    it "must be true if an email is available" do
      download = Noodall::Download.new
      download.email = 'test@example.com'
      download.email_when_ready?.should be_true
    end
  end
end
