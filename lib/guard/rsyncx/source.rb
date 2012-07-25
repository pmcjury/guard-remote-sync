module Guard
  class RsyncX
    class Source

      attr_accessor :directory

      def initialize(directory)
        @directory = directory
      end

    end
  end
end