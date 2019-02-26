# DefInitialize (WIP)

Another approach to reduce initialization boilerplate


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'def_initialize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install def_initialize

## Usage

```ruby
class Employee
  extend DefInitialize.with("name, uuid = SecureRandom.uuid, age, position: 'manager'")
end

# is the same as:

class Employee
  attr_reader :name, :uuid, :age, :position

  def initialize(name, uuid = SecureRandom.uuid, age:, position: 'manager')
    @name = name
    @uuid = uuid
    @age = age
    @position = position
  end
end
```

### What should I do in more complex cases?

Just write old plain `def initialize`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/antoshalee/def_initialize.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
