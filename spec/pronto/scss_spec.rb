require 'spec_helper'

module Pronto
  describe Scss do
    let(:scss) { Scss.new }

    describe '#run' do
      subject { scss.run(patches, nil) }

      context 'patches are nil' do
        let(:patches) { nil }
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end
    end
  end
end
