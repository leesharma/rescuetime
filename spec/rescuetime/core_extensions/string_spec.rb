require 'spec_helper'

describe Rescuetime::CoreExtensions::String do
  it { should be_a_kind_of String }
  it { should respond_to :present? }
  it { should respond_to :blank? }
end
