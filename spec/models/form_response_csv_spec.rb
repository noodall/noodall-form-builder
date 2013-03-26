require 'spec_helper'

describe Noodall::FormResponseCsv do
  before do
    @form = create(:form)
    @form.fields = [
      create(:text_field, :name => 'Name', :required => true),
      create(:text_field, :name => 'Email', :required => true)
    ]

    jeff = create(
      :response,
      form: @form,
      name: "Jeff",
      email: "jeff@jefferson.com",
      created_at: "2012-08-14 11:05:41",
      approved: true
    )

    bob = create(
      :response,
      form: @form,
      name: "Bob",
      email: "bob@bobbington.com",
      created_at: "2011-02-11 09:53:23",
      approved: true
    )

    frank = create(
      :response,
      form: @form,
      name: "Frank",
      email: "frank@frankington.com",
      created_at: "2012-12-01 09:53:23",
      approved: true
    )
  end

  it "should accept a form" do
    csv = Noodall::FormResponseCsv.new(@form).output

    csv.should == <<-EOS.strip_heredoc
      Name,Email,Date,IP,Form Location
      Frank,frank@frankington.com,"December 01, 2012 09:53",127.0.0.1,http://rac.local/the-college
      Jeff,jeff@jefferson.com,"August 14, 2012 11:05",127.0.0.1,http://rac.local/the-college
      Bob,bob@bobbington.com,"February 11, 2011 09:53",127.0.0.1,http://rac.local/the-college
    EOS
  end

  describe "filtering by date" do
    it "should filter by date" do
      conditions = { "month"=>"8", "year"=>"2012" }
      csv = Noodall::FormResponseCsv.new(@form, conditions).output

      csv.should == <<-EOS.strip_heredoc
        Name,Email,Date,IP,Form Location
        Jeff,jeff@jefferson.com,"August 14, 2012 11:05",127.0.0.1,http://rac.local/the-college
      EOS
    end

    it "should filter correctly when at the end of the year" do
      conditions = { "month"=>"12", "year"=>"2012" }
      csv = Noodall::FormResponseCsv.new(@form, conditions).output

      csv.should == <<-EOS.strip_heredoc
        Name,Email,Date,IP,Form Location
        Frank,frank@frankington.com,"December 01, 2012 09:53",127.0.0.1,http://rac.local/the-college
      EOS
    end
    
    it "should return all responses when :month == 'all' & :year == 'all' " do
      conditions = { "month"=>"all", "year"=>"all" }
      csv = Noodall::FormResponseCsv.new(@form, conditions).output

      csv.should == <<-EOS.strip_heredoc
        Name,Email,Date,IP,Form Location
        Frank,frank@frankington.com,"December 01, 2012 09:53",127.0.0.1,http://rac.local/the-college
        Jeff,jeff@jefferson.com,"August 14, 2012 11:05",127.0.0.1,http://rac.local/the-college
        Bob,bob@bobbington.com,"February 11, 2011 09:53",127.0.0.1,http://rac.local/the-college
      EOS
    end
    
    it 'should return all responses when month == :all & year == :all' do
      conditions = { 'month' => :all, 'year' => :all }
      csv = Noodall::FormResponseCsv.new(@form, conditions).output

      csv.should == <<-EOS.strip_heredoc
        Name,Email,Date,IP,Form Location
        Frank,frank@frankington.com,"December 01, 2012 09:53",127.0.0.1,http://rac.local/the-college
        Jeff,jeff@jefferson.com,"August 14, 2012 11:05",127.0.0.1,http://rac.local/the-college
        Bob,bob@bobbington.com,"February 11, 2011 09:53",127.0.0.1,http://rac.local/the-college
      EOS
    end
    
  end

  it "should only include non-spam form responses" do
    spam = create(
      :response,
      form: @form,
      name: "Spam",
      email: "spam@spammer.com",
      created_at: "2011-02-11 09:53:23",
      checked: true, # So the object doesn't get checked on creation
      approved: false
    )

    csv = Noodall::FormResponseCsv.new(@form).output

    csv.should == <<-EOS.strip_heredoc
      Name,Email,Date,IP,Form Location
      Frank,frank@frankington.com,"December 01, 2012 09:53",127.0.0.1,http://rac.local/the-college
      Jeff,jeff@jefferson.com,"August 14, 2012 11:05",127.0.0.1,http://rac.local/the-college
      Bob,bob@bobbington.com,"February 11, 2011 09:53",127.0.0.1,http://rac.local/the-college
    EOS
  end
end
