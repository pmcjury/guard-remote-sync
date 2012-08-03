require "spec_helper"

describe Guard::RemoteSync::Command do

  before(:each) do
    File.stub!(:directory?).and_return(true)
  end

  describe "#initialize" do

    let(:source) do
      Guard::RemoteSync::Source.new("./source")
    end

    let(:destination) do
      Guard::RemoteSync::Source.new("./destination")
    end

    context "when :cli_options is given and other options are set" do
      subject { command }
      let(:command) do
        Guard::RemoteSync::Command.new(nil, nil, {
            :cli_options => "-arv --exclude '*.*'",
            :progress => true,
            :include => "*.txt"
        })
      end

      specify { subject.command.should eql "rsync -arv --exclude '*.*'" }

    end

    context "when :progress and :delete boolean options are given" do
      subject { command }
      let(:command) do
        Guard::RemoteSync::Command.new(source, destination, {
            :progress => true,
            :delete => true,
        })
      end

      specify { subject.command.should eql "rsync --progress --delete ./source ./destination" }

    end

    context "when :include and :exclude nil options are given" do
      subject { command }
      let(:command) do
        Guard::RemoteSync::Command.new(source, destination, {
            :include => "*.rb",
            :exclude => "*.txt",
        })
      end

      specify { subject.command.should eql "rsync --include '*.rb' --exclude '*.txt' ./source ./destination" }

    end

    context "when :dry_run option is set to true" do
      subject { command }
      let(:command) do
        Guard::RemoteSync::Command.new(source, destination, {
            :dry_run => true
        })
      end

      specify { subject.command.should eql "rsync --dry-run ./source ./destination" }

    end

    context "when simple options are given" do

      context "when :archive is set to true" do
        subject { command }
        let(:command) do
          Guard::RemoteSync::Command.new(source, destination, {
              :archive => true,
          })
        end

        specify { subject.command.should eql "rsync -a ./source ./destination" }
      end

      context "and :recursive is set to true" do
        subject { command }
        let(:command) do
          Guard::RemoteSync::Command.new(source, destination, {
              :recursive => true
          })
        end

        specify { subject.command.should eql "rsync -r ./source ./destination" }
      end

      context "and :verbose is set to true" do
        subject { command }
        let(:command) do
          Guard::RemoteSync::Command.new(source, destination, {
              :verbose => true
          })
        end

        specify { subject.command.should eql "rsync -v ./source ./destination" }
      end

      context "and :verbose and :recursive are set to true" do
        subject { command }
        let(:command) do
          Guard::RemoteSync::Command.new(source, destination, {
              :recursive => true,
              :verbose => true
          })
        end

        specify { subject.command.should eql "rsync -rv ./source ./destination" }
      end

    end

    context "user and remote address for remote rsync" do
      subject { command }
      let(:destination) do
        Guard::RemoteSync::Source.new("/remote/destination")
      end
      context "user options is given, and remote address is given" do
        let(:command) do
          Guard::RemoteSync::Command.new(source, destination, {
              :user => "test",
              :remote_address => "192.168.1.1"
          })
        end
        specify { subject.command.should eql "rsync ./source test@192.168.1.1:/remote/destination" }
      end

      context "user options is given, and remote address is not given" do
        it "should raise an error about remote address" do
          expect { described_class.new(source, destination, {:user => "test", :remote_address => nil}) }.to raise_error(StandardError)
        end
      end

      context "user options is not given, and remote address is given" do
        it "should raise an error about remote address" do
          expect { described_class.new(source, destination, {:user => nil, :remote_address => "/remote/"}) }.to raise_error(StandardError)
        end
      end

    end

  end

  describe "#sync" do
    let(:source) do
      Guard::RemoteSync::Source.new("./source")
    end
    let(:destination) do
      Guard::RemoteSync::Source.new("/remote/destination")
    end

    context "some options are passed to initialize" do
      it "should send the rsync command to the system" do
        command = Guard::RemoteSync::Command.new(source, destination, {
                    :user => "test",
                    :remote_address => "192.168.1.1",
                    :archive => true,
                    :recursive => true
                })

        command.should_receive(:`).with("rsync -ar ./source test@192.168.1.1:/remote/destination")
        command.sync
      end
    end
  end
end