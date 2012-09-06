require 'spec_helper'

describe Noodall::Queue do
  it "should allow downloads to be added to the queue" do
    GenerateCsv = Class.new

    queue = double(:real_queue)
    queue.should_receive(:enqueue).with(GenerateCsvJob, 1234)

    queue = Noodall::Queue.new(:queue => queue)
    queue.add(GenerateCsvJob, 1234)
  end
end

