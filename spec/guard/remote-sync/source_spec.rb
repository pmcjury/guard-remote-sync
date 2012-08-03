require "spec_helper"

describe Guard::RemoteSync::Source do

  describe "#initialize" do

    let(:source) do
      described_class.new "."
    end
    #subject( source )

    context "when a directory is given" do
      subject{ source.directory }
      it { should_not be_nil}
    end
  end
end
