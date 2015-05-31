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

      context 'patches with a two smells' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 2 }
        its(:'first.msg') do
          should ==
            'Line should be indented 2 spaces, but was indented 4 spaces'
        end

        its(:'last.msg') do
          should ==
            'Line should be indented 2 spaces, but was indented 4 spaces'
        end
      end
    end
  end
end
