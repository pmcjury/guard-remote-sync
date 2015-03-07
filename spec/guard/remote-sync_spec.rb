require "spec_helper"

describe Guard::RemoteSync do

  before(:each) do
    File.stub!(:directory?).and_return(true)
    ::Guard::Compat::UI.stub!(:info)
  end

  describe "#initialize" do

  end

  describe "#start" do

    context "when no :source option is given" do
      it "should send an error notification and stop" do
        ::Guard::Compat::UI.should_receive(:error)
        expect {
          guard = described_class.new({:destination => "."})
          guard.start
        }.to raise_exception
      end
    end

    context "when no :destination option is given" do
      it "should send an error notification and stop" do
        ::Guard::Compat::UI.should_receive(:error)
        expect {
          guard = described_class.new({:source => "."})
          guard.start
        }.to raise_exception
      end
    end

    context "when no :source and no :destination options are given" do
      it "should send 2 error notification and stop" do
        ::Guard::Compat::UI.should_receive(:error).at_least 2
        expect {
          guard = described_class.new({})
          guard.start
        }.to raise_exception
      end

    end

    context "when starting rsync guard" do
      let(:source) do
        "./source"
      end
      let(:destination) do
        "/remote/destination"
      end
      it "should call the Compat::UI::info with the following message" do
        File.stub!(:expand_path).and_return(source)
        # ::Guard::UI.turn_off
        ::Guard::Compat::UI.should_receive(:debug).with("Guard::RemoteSync building rsync options from specified options")
        ::Guard::Compat::UI.should_receive(:info).with("Guard::RemoteSync started in source directory '#{source}'")
        guard = described_class.new({:source => source, :destination => destination})
        guard.command.stub!(:test).and_return(true)
        guard.command.stub!(:sync).and_return(true)
        guard.start
      end

      it "should call command#sync on the system when :sync_on_start is true and command#test is true" do
        guard = described_class.new({:source => source, :destination => destination, :sync_on_start => true})
        guard.command.stub!(:test).and_return(true)
        guard.command.should_receive(:sync).once
        guard.start
      end
    end
  end

  describe "guard methods that get called when files change or the guard stops" do

    let(:guard) do
      described_class.new({:source => "./source", :destination => "./destination"})
    end

    describe "#stop" do
      context "when the guard is stopped" do
        it "should output the following message" do
          ::Guard::Compat::UI.should_receive(:debug).with("Guard::RemoteSync building rsync options from specified options")
          ::Guard::Compat::UI.should_receive(:info).with("Guard::RemoteSync stopped.")
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
