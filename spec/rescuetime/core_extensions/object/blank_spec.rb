require 'spec_helper'

describe Rescuetime::CoreExtensions::Object::Blank do
  let(:blank) { Rescuetime::CoreExtensions::Object::Blank }
  context 'when the object is nil' do
    let(:object) { nil.extend blank }

    describe '#blank?' do
      it 'returns true' do
        expect(object).to be_blank
      end
    end

    describe '#present?' do
      it 'returns false' do
        expect(object).not_to be_present
      end
    end
  end

  context 'when the object is false' do
    let(:object) { false.extend blank }

    describe '#blank?' do
      it 'returns true' do
        expect(object).to be_blank
      end
    end

    describe '#present?' do
      it 'returns false' do
        expect(object).not_to be_present
      end
    end
  end

  context 'when the object is empty' do
    let(:object) {
      object = Object.new
      allow(object).to receive(:empty?) { true }
      object.extend blank
    }

    describe '#blank?' do
      it 'returns true' do
        expect(object).to be_blank
      end
    end

    describe '#present?' do
      it 'returns false' do
        expect(object).not_to be_present
      end
    end
  end

  context 'when the object is true' do
    let(:object) { true.extend blank }

    describe '#blank?' do
      it 'returns false' do
        expect(object).not_to be_blank
      end
    end

    describe '#present?' do
      it 'returns true' do
        expect(object).to be_present
      end
    end
  end

  context 'when the object is true' do
    let(:object) { Object.extend blank }

    describe '#blank?' do
      it 'returns false' do
        expect(object).not_to be_blank
      end
    end

    describe '#present?' do
      it 'returns true' do
        expect(object).to be_present
      end
    end
  end

  context 'when the object is not empty' do
    let(:object) {
      object = Object.new
      allow(object).to receive(:empty?) { false }
      object.extend blank
    }

    describe '#blank?' do
      it 'returns false' do
        expect(object).not_to be_blank
      end
    end

    describe '#present?' do
      it 'returns true' do
        expect(object).to be_present
      end
    end
  end
end
