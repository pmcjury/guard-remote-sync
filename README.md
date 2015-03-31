#Guard::RemoteSync [![Build Status](https://travis-ci.org/pmcjury/guard-remote-sync.svg?branch=master)](https://travis-ci.org/pmcjury/guard-remote-sync) [![Dependency Status](https://gemnasium.com/pmcjury/guard-remote-sync.png)](https://gemnasium.com/pmcjury/guard-remote-sync) [![Code Climate](https://codeclimate.com/github/pmcjury/guard-remote-sync.png)](https://codeclimate.com/github/pmcjury/guard-remote-sync) [![Gem Version](https://badge.fury.io/rb/guard-remote-sync.svg)](http://badge.fury.io/rb/guard-remote-sync)

## Install

### Requirements

The gem has been update to be compatable with guard ```"guard", "~> 2.12.4"``` and the ruby version below. 

  - 1.9.3
  - 2.0.0
  - 2.1.2

Please be sure to have [Guard](https://github.com/guard/guard) installed before continuing.

Please be sure to have the rsync command in your path.

It's recommended that you set up a ssh key if you're going to do remote syncing. 
Alterantively your can use a password file as per rsync default option --password-file=FILE, the drawback with this is you might commit your information to the repo, and that ain't no good.
Lastly, you can just type in your password everytime, but that's too much work. Add a ssh key! 

### Installation

Install the gem:

```
$ gem install guard-remote-sync
```

Add guard definition to your Guardfile by running this command:

```
$ guard init remote-sync
```

## Usage

Please read [Guard usage doc](https://github.com/guard/guard#readme)

## Guardfile

### Any directory you need to rsync

```ruby
guard 'remote-sync',
        :source => ".", 
        :destination => '/export/home/{username}/tmp', 
        :user => '{user}',
        :remote_address => '{address}',
        :verbose => true, 
        :cli => "--color", 
        :sync_on_start => true do
  
  watch(%r{^.+\.(js|xml|php|class|config)$})
end
```
Please read [Guard doc](https://github.com/guard/guard#readme) for more information about the Guardfile DSL.

## Options

### There are only two required options

```ruby
guard 'remote-sync', :source => '.', :destination => './tmp' do
        # ...
end
```

### Syncing to a remote machine required additional options
```ruby
guard 'remote-sync', 
        :source => "."                      # the directory to start the remote sync guard in
        :destination => '/export/home/user' # the directory to sync to
        :user => "someone"                  # the user to user ex: {USER}@somehost.com
        :remote_address => 'company.com'    # the remote address ip or url
        do
                # ...
end
```

### Using your own rsync command. This bypasses all validations, etc.
```ruby
guard 'remote-sync', :cli_options => 'rsync -Carv . user@company.com:/export/home/user' do
        # ...
end
```

### List of available options:

Most of these options are human readable and correspond to rsync's options. Long options are used wherever
possible to be more verbose

```ruby
:source => nil                      # the source directory to start in
:destination => nil                 # the directory to sync to
:user => nil                        # the user to use if remote syncing to another machine
:remote_address => nil              # the remote address to the other machine ip|url
:remote_port => nil                 # the port to use for ssh connetions
:ssh => false                       # see rsync options : "$ man rsync"
:auth_key => nil                    # the identity file to use for ssh authentication
:cli_options => nil                 # used if you want to pass your own rsyn command
:archive => true                    # see rsync options : "$ man rsync"
:recursive => true                  # see rsync options : "$ man rsync"
:verbose => true                    # see rsync options : "$ man rsync"
:delete => true                     # see rsync options : "$ man rsync"
:include => nil                     # see rsync options : "$ man rsync"
:include_from => nil                # see rsync options : "$ man rsync"
:exclude => nil                     # see rsync options : "$ man rsync"
:exclude_from => ".rsync-filter"    # see rsync options : "$ man rsync"
:progress => true                   # see rsync options : "$ man rsync"
:sync_on_start => false             # rsycn when the guard starts instead of waiting for a watcher to trigger guard
:dry_run => false                   # see rsync options : "$ man rsync"
:cvs_exclude => false               # see rsync options : "$ man rsync"
:password_file => nil               # see rsync options : "$ man rsync"
:timeout => 9999                    # see rsync options : "$ man rsync"
```

Development
-----------

* Source hosted at [GitHub](https://github.com/pmcjury/guard-remote-sync)
* Report issues/Questions/Feature requests on [GitHub Issues](https://github.com/pmcjury/guard-remote-sync/issues)

Testing
-------

Please run `bundle exec rake spec` to test the source

Author
------

[Patrick H. McJury](https://github.com/pmcjury)
