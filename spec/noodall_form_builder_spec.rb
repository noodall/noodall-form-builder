require 'spec_helper'

describe Noodall::FormBuilder::Form do
  it "should be valid" do
    Noodall::FormBuilder::Form.should be_a(Module)
  end
end
