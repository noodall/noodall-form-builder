require 'spec_helper'

describe Noodall::FormResponsesDownload do

  before do
    @form = double(:form)
    @form.stub(id: 1234, title: 'A form')

    @conditions = { month: 1, year: 2011 }
  end

  context "when email is provided" do

    it "must pass the email to the download object" do
      csv_generator = double(:output => 'NOT BLANK')
      Noodall::FormResponseCsv.should_receive(:new).and_return(csv_generator)

      download = Noodall::FormResponsesDownload.new(@form, @conditions, 'test@example.com')

      csv = download.generate
      csv.email.should == 'test@example.com'
      csv.email_when_ready?.should == true
    end
  end

  context "background queuing is turned off" do
    before do
      Noodall::FormBuilder.use_background_queue = false
    end

    it "should generate a new CSV" do
      csv_generator = double(:output => 'NOT BLANK')
      csv_generator.should_receive(:output)

      Noodall::FormResponseCsv.should_receive(:new).and_return(csv_generator)

      download = Noodall::FormResponsesDownload.new(@form, @conditions)

      csv = download.generate
      csv.output.should_not be_nil
      csv.new_record?.should be_false
    end
  end

  context "background queuing is enabled" do
    before do
      Noodall::FormBuilder.use_background_queue = true
    end

    it "should queue the download" do
      queue = double(:queue)
      queue.should_receive(:add)

      download = Noodall::FormResponsesDownload.new(@form, @conditions)
      download.queue = queue

      csv = download.generate
      csv.output.should be_nil
      csv.new_record?.should be_false
    end
  end
end
