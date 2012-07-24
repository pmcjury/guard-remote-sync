require "spec_helper"

describe Guard::RsyncX::Source do

  describe "#initialize" do

    context "when an invalid valid directory is given" do
      it "should raise_error" do
        expect { described_class.new("./not_a_valid_directory_test_me") }.to raise_error(StandardError)
      end

    end

    context "when a directory is given" do
      it "should not raise_error" do
        expect { described_class.new(".") }.to_not raise_error(StandardError)
      end

    end
  end
end
