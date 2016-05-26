require 'spec_helper'

describe Rescuetime::Collection do
  let(:collection) { Rescuetime::Collection.new }

  describe '#<<' do
    it 'appends a new term onto the Rescuetime::Collection'
  end

  describe '#all' do
    it 'performs the Rescuetime query'
  end

  describe '#each' do
    it 'performs the Rescuetime query'
    it 'enumerates over the items in the resulting collection'
  end

  describe '#format' do
    it 'sets the report format'
  end
end
