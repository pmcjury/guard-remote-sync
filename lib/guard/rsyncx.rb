require 'guard'
require 'guard/guard'

module Guard
  class RsyncX < Guard

    autoload :Command, 'guard/rsyncx/command'
    autoload :Source, 'guard/rsyncx/source'

    attr_accessor :command

    # Initialize a Guard.
    # @param [Array<Guard::Watcher>] watchers the Guard file watchers
    # @param [Hash] options the custom Guard options
    def initialize(watchers = [], options = {})
      super
      @options = {
          :source => nil,
          :destination => nil,
          :user => nil,
          :remote_address => nil,
          :ssh => false,
          :cli_options => nil,
          :archive => true,
          :recursive => true,
          :verbose => true,
          :delete => true,
          :include => nil,
          :include_from => nil,
          :exclude => nil,
          :exclude_from => ".rsync-filter",
          :progress => true,
          :sync_on_start => false,
          :dry_run => false,
          :cvs_exclude => true,
          :password_file => nil
      }.merge(options)

      @source = Source.new(options[:source])
      @destination = Source.new(options[:destination])
      @command = Command.new(@source, @destination, @options)

    end

    # Call once when Guard starts. Please override initialize method to init stuff.
    # @raise [:task_has_failed] when start has failed
    def start
      throw([:task_has_failed], "Guard::RsyncX options invalid") unless options_valid?
      UI.info "Guard::RsyncX started in source directory '#{File.expand_path @source.directory}'"
      Notifier.notify("Guard::RsyncX is running in directory #{File.expand_path @source.directory}", notifier_options)
      @command.sync if options[:sync_on_start] && @command.test

    end

    # Called when `stop|quit|exit|s|q|e + enter` is pressed (when Guard quits).
    # @raise [:task_has_failed] when stop has failed

    def stop
      UI.info "Guard::RsyncX stopped."
      Notifier.notify("Guard::RsyncX stopped.",notifier_options)
    end

    # Called when `reload|r|z + enter` is pressed.
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    # @raise [:task_has_failed] when reload has failed
    def reload
      Notifier.notify("Manual Guard::RsyncX synchronize  #{File.expand_path @source.directory} to #{@destination.directory}",notifier_options)
      @command.sync
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      Notifier.notify("Manual Guard::RsyncX synchronize  #{@source.directory} to #{@destination.directory}",notifier_options)
      @command.sync
    end

    # Called on file(s) modifications that the Guard watches.
    # @param [Array<String>] paths the changes files or paths
    # @raise [:task_has_failed] when run_on_change has failed
    def run_on_changes(paths)
      #paths.each do |p| ::Guard::UI.info("Files effect : #{p}")  end
      @command.sync
    end

    # Called on file(s) deletions that the Guard watches.
    # @param [Array<String>] paths the deleted files or paths
    # @raise [:task_has_failed] when run_on_removals has failed
    def run_on_removals(paths)
      @command.sync
    end

    # Called on file(s) additions that the Guard watches.
    # @param [Array<String>] paths the added files or paths
    # @raise [:task_has_failed] when run_on_additions has failed
    def run_on_additions(paths)
      @command.sync
    end

    private

    def options_valid?
      valid = true
      if options[:source].nil? && options[:cli_options].nil?
        UI.error("Guard::RsyncX a source directory is required")
        valid = false
      end
      if options[:destination].nil? && options[:cli_options].nil?
        UI.error("Guard::RsyncX a source directory is required")
        valid = false
      end
      valid
    end

    def notifier_options
      {:title => "Guard::RsyncX", :image => :success}
    end

  end
end
