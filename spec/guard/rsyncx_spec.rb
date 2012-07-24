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

  describe "#start" do

    let(:source) do
      "./source"
    end
    let(:destination) do
      "/remote/destination"
    end

    context "when starting rsync guard" do
      it "should call the UI::info with the following message" do
        ::Guard::UI.should_receive(:info).with("Guard::RsyncX is running in source directory #{source}!")
        guard = described_class.new(nil, {:source => source, :destination => destination})
        guard.start
      end

      it "should call rsync on the system when :sync_on_start is true and command#test" do
        guard = described_class.new(nil, {:source => source, :destination => destination, :sync_on_start => true})
        guard.command.stub!(:test).and_return(true)
        guard.command.should_receive(:sync).once
        guard.start
      end
    end
  end

  describe "guard methods that get called when files change or the guard stops" do

    let(:guard) do
      described_class.new(nil, {:source => "./source", :destination => "./destination"})
    end

    describe "#stop" do
      context "when the guard is stopped" do
        it "should output the following message" do
          ::Guard::UI.should_receive(:info).with("Guard::RsyncX is stopped in source directory ./source!")
          guard.stop
        end
      end
    end

    describe "#run_on_changes" do
      context "when the guard detects changes in the watched files" do
        it "should call guard.command#sync" do
          guard.command.should_receive(:sync).once
          guard.run_on_changes ""
        end
      end
    end

    describe "#run_on_removals" do
      context "when the guard detects file removals" do
        it "should call guard.command#sync" do
          guard.command.should_receive(:sync).once
          guard.run_on_removals ""
        end
      end
    end

  end

end