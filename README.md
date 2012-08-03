guard-rsync-remote
============

**Usage**
```
bundle exec guard
```

**Example Guardfile**
```
guard 'rsync-remote',
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

A more extensive and tested rsync guard
