require 'open3'
require 'guard/compat/plugin'

module Guard
  class RemoteSync
    class Command

      attr_accessor :command, :source, :destination

      CLEAR = "\e[0m"
      # The start of an ANSI bold sequence.
      BOLD = "\e[1m"
      # Set the terminal's foreground ANSI color to black.
      BLACK = "\e[30m"
      # Set the terminal's foreground ANSI color to red.
      RED = "\e[31m"
      # Set the terminal's foreground ANSI color to green.
      GREEN = "\e[32m"
      # Set the terminal's foreground ANSI color to yellow.
      YELLOW = "\e[33m"
      # Set the terminal's foreground ANSI color to blue.
      BLUE = "\e[34m"
      # Set the terminal's foreground ANSI color to magenta.
      MAGENTA = "\e[35m"
      # Set the terminal's foreground ANSI color to cyan.
      CYAN = "\e[36m"
      # Set the terminal's foreground ANSI color to white.
      WHITE = "\e[37m"

      def initialize(source, destination, options = {})
        @options = options
        @source = source
        @destination = destination
        @command = build_command
      end

      def sync
        Compat::UI.info "Guard::RemoteSync `#{@command}`"
        run_command @command
      end

      def test
        $stderr.puts("\r\e[0m")
        $stderr.puts "#{BOLD}Testing rsync with a dry run and stats. Verifying the results...#{CLEAR}"
        opts = @options
        @options[:dry_run] = true
        @options[:stats] = true
        test_command = build_command
        @options = opts
        result = run_command test_command, {:suppress_output => false}
        $stderr.puts("\r\e[0m")
        result.to_i == 0
      end

      private

      def run_command(cmd, opts = {})
        options = {:color => CYAN, :suppress_output => false}.merge(opts)
        $stderr.puts "\r\e[0m" unless options[:suppress_output]
        exit_value = nil
        wait_thread = nil
        Open3.popen3(cmd) do |stdin, stdout, stderr, wait_thr|
          stdout.read.split("\n").each do |line|
            $stderr.puts "\t#{options[:color]}#{line}#{CLEAR}" unless options[:suppress_output]
          end
          stderr.read.split("\n").each do |line|
            $stderr.puts "\t#{BOLD}#{RED}ERROR:#{line}#{CLEAR}"
          end
          if !wait_thr.nil?
            exit_value = wait_thr.value.to_s.split.last
            wait_thread = wait_thr
          end
        end
        $stderr.puts "\t#{BOLD}#{YELLOW}Result Code #{exit_value}#{CLEAR}"
        !wait_thread.nil? ? exit_value : nil
      end

      def build_command
        unless @options[:cli_options].nil?
          Guard::Compat::UI.debug "Guard::RemoteSync ':cli' option was given so ignoring all other options, and outputting as is..." if @options[:verbose]
          command = "#{rsync_command} #{@options[:cli_options]}"
        else
          ::Guard::Compat::UI.debug "Guard::RemoteSync building rsync options from specified options" if @options[:verbose]
          @command_options = build_options
          @remote_options = check_remote_options
          @ssh_options = check_ssh_options
          destination = @remote_options.nil? ? "#{@destination.directory}" : "#{@remote_options}:#{@destination.directory}"
          command = "#{rsync_command} #{@command_options}#{@source.directory} #{destination}"
          command << " #{@ssh_options}" unless @ssh_options.nil?
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
        [:include, :include_from, :exclude, :exclude_from, :password_file, :timeout].each do |o|
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

      def check_ssh_options
        unless @options[:remote_port].nil? && @options[:auth_key].nil?
          raise ":remote_port is an invalid option for local destinations" if !@options[:remote_port].nil? && @remote_options.nil?
          raise ":auth_key is an invalid option for local destinations" if !@options[:auth_key].nil? && @remote_options.nil?
          value = "-e \"ssh"
          value << " -i #{@options[:auth_key]}" if !@options[:auth_key].nil?
          value << " -p #{@options[:remote_port]}" if !@options[:remote_port].nil?
          value << "\""
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
