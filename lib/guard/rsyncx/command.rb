module Guard
  class RsyncX
    class Command

      attr_accessor :command, :source, :destination

      def initialize(source, destination, options = {})
        @options = options
        @source = source
        @destination = destination
        @command = build_command
      end

      def sync
        UI.info "Guard::RsyncX `#{@command}`"
        r = `#{@command}`
        UI.info "Guard::RsyncX Status : \n #{r}" if @options[:verbose]
      end

      def test
        @options[:dry_run] = true
        test_command = build_command
        @options[:dry_run] = false
        `#{test_command}`
        $?.exitstatus
      end

      private

      def build_command
        unless @options[:cli_options].nil?
          UI.info "':cli' option was given so ignoring all other options, and outputting as is..."
          command = "#{rsync_command} #{@options[:cli_options]}"
        else
          UI.debug "building rsync options from specified options"
          @command_options = build_options
          @remote_options = check_remote_options
          destination = @remote_options.nil? ? "#{@destination.directory}" : "#{@remote_options}:#{@destination.directory}"
          command = "#{rsync_command} #{@command_options}#{@source.directory} #{destination}"
        end
        command
      end

      def build_options
        opts = ""
        simple_opts = ""
        [:archive, :recursive, :verbose].each do |o|
          value = check_simple_option(o)
          simple_opts.concat "#{value}" unless value.nil?
        end
        opts.concat "-#{simple_opts} " unless simple_opts.empty?

        [:progress, :delete, :stats, :dry_run, :cvs_exclude].each do |o|
          value = check_boolean_option(o)
          opts.concat "#{value} " unless value.nil?
        end
        [:include, :include_from, :exclude, :exclude_from, :password_file].each do |o|
          value = check_nil_option(o)
          opts.concat "#{value} " unless value.nil?
        end

        opts
      end

      def rsync_command
        "rsync"
      end

      def check_remote_options
        unless @options[:user].nil? && @options[:remote_address].nil?
          raise "A remote address is required if you specify a user" if !@options[:user].nil? && @options[:remote_address].nil?
          raise "A user is required if you specify a remote address" if @options[:user].nil? && !@options[:remote_address].nil?
          value = "#{@options[:user]}@#{@options[:remote_address]}"
        else
          value = nil
        end
        value
      end

      def check_boolean_option(option)
        @options[option] ? "--#{option.to_s.gsub(/_/, '-')}" : nil
      end

      def check_nil_option(option)
        @options[option].nil? ? nil : "--#{option.to_s.gsub(/_/, '-')} '#{@options[option]}'"
      end

      def check_simple_option(option)
        @options[option] ? "#{option.to_s[0, 1]}" : nil
      end

    end
  end
end
