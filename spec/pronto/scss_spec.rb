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

      context 'patches with a three smells' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 3 }

        its(:'first.msg') do
          should ==
            'Line should be indented 2 spaces, but was indented 4 spaces'
        end

        its(:'last.msg') do
          should ==
            'Each selector in a comma sequence should be on its own single line'
        end

        context 'only one file with one smell included by `scss_files` option' do
          before(:all) do
            File.open('spec/.scss-lint.yml', 'w') do |file|
              file.write "scss_files: '**/world*scss'\n"
            end
          end

          after(:all) { FileUtils.rm('spec/.scss-lint.yml') }

          before do
            scss.should_receive(:config) do
              SCSSLint::Config.load('spec/.scss-lint.yml')
            end.at_least(:once)
          end

          its(:count) { should == 1 }

          its(:'first.msg') do
            should ==
              'Each selector in a comma sequence should be on its own single line'
          end
        end
      end
    end
  end
end
