guard-remote-sync [![Build Status](https://secure.travis-ci.org/pmcjury/guard-remote-sync.png)](http://travis-ci.org/pmcjury/guard-remote-sync)
============

**Usage**
```
bundle exec guard
```

**Example Guardfile**
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
