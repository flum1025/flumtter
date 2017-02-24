# Flumtter
Flumtter is CLI Twitter client.
This client is supported multiple account.

## Installation
    $ gem install flumtter

## Usage
    $ flumtter
and help

    $ flumtter -h
    Usage: flumtter [options]
    -n, --name VALUE                 account name
    -i, --index VALUE                account index
    -s, --non_stream                 without stream
    -d, --debug                      debug mode
        --args VALUE
        --timeline_load VALUE        load timeline num
        --[no-]timeline_load?        load timeline on init
        --pry                        console mode

Detailed usage: [How To Use](https://github.com/flum1025/flumtter/wiki/How-To-Use)

## Customize
There is a configuration file on `~/.flumtter/setting/setting.rb`. This setting is overwritten by start option. This file needs to be described in ruby's hash format. This file will be created automatically and should ONLY be edited by someone who knows what they are doing.

```ruby
Setting = {
  color: {
    error: :red,
    timeline: {
      normal:         :cyan,
      self:           :light_green,
      reply:          :blue,
      retweet:        :green,
      fav:            :brown,
      unfav:          :yellow,
      quote:          :pink,
      directmessage:  :purple,
      deletedtweet:   [:cyan, :magenta]
    }
  },
  timeline_load?: true,
  timeline_load: 20,
  toast?: true
}
```

## Development
### Plugin
You can develop plugins to convenient.
Put your plugin files to `~/.flumtter/plugins/`
Please see [flumtter/lib/flumtter/app/plugins/](https://github.com/flum1025/flumtter/tree/v5/lib/flumtter/app/plugins) for sample.

### Reporting bugs
If you have found a bug in flumtter, please create a new issue.
Also, feel free to request any other features not present in the issue tracker.
Feedback on plugin will be greatly appreciated!

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/flum1025/flumtter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
