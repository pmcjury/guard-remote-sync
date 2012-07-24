require "spec_helper"

describe Guard::RsyncX do

  before(:each) do
    File.stub!(:directory?).and_return(true)
  end

  describe "#initialize" do
    #subject { described_class.new }
    context "when no :source option is given" do
      it should raise_error do
        expect { described_class.new }.to raise_error(StandardError)
      end
    end

    context "when no :destination option is given" do
      it "should raise error" do
        expect { described_class.new }.to raise_error(StandardError)
      end
    end

    context "when :source and :destination options are given" do
      subject { guard }
      let(:guard) do
        Guard::RsyncX.new(nil, {
            :source => "./source",
            :destination => "./destination"
        })
      end

      it { should_not be_nil }
      specify { subject.should_not be_nil }

    end
  end
end