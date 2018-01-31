# Activerecord Settings

This gem creates a very simple activerecord based key value store. It can be useful if you want a place to store stuff that is more durable than a redis/memcache cache, or you simply don't want or need the complexity of running an additional cache.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord_settings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord_settings

## Usage

Create the migration to create the activerecord table with

    bundle exec rails g activerecord_settings:install
    
Then you can set and get values like this

    ActiverecordSettings::Setting.set('key', anything_yaml_can_serialize)
    ActiverecordSettings::Setting.get('key')
    => anything_yaml_can_serialize
    
You can also set keys to have expiries

    ActiverecordSettings::Setting.set('key', 'It's morning', expires: 10.minutes.from_now)
    ActiverecordSettings::Setting.get('key')
    => 'It's morning'
    # Some time passes, Thorin sings about gold
    ActiverecordSettings::Setting.get('key')
    => nil
    
 ```ActiverecordSettings::Setting``` is a bit of a mouthful, so you can create a shorthand for it by putting something like the following in an initiliazer
 
    Setting = ActiverecordSettings::Setting
    
And then you can do this

    Setting.set('key', anything_yaml_can_serialize)
    Setting.get('key')
    => anything_yaml_can_serialize

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dansingerman/activerecord_settings.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
