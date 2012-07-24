module Guard
  class RsyncX
    class Source

      attr_accessor :directory

      def initialize(directory)
        raise "#{directory} is not a directory!" unless File.directory? directory
        @directory = directory
      end
    end
  end
end