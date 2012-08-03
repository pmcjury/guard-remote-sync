module Guard
  class RemoteSync
    class Source

      attr_accessor :directory

      def initialize(directory)
        @directory = directory
      end

    end
  end
end