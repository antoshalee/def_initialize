[![Build Status](https://travis-ci.org/antoshalee/def_initialize.svg?branch=master)](https://travis-ci.org/antoshalee/def_initialize)

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
  include DefInitialize.with("name, uuid = SecureRandom.uuid, age:, position: 'manager'")
end

# is the same as:

class Employee
  def initialize(name, uuid = SecureRandom.uuid, age:, position: 'manager')
    @name = name
    @uuid = uuid
    @age = age
    @position = position
  end

  private

  attr_reader :name, :uuid, :age, :position
end
```

By convention, parameters starting with underscore symbol `'_'` are ignored:

```ruby
class Point
  include DefInitialize.with("x, y, _c")
end

# transforms to:

class Point
  def initialize(x, y, _c) # Note that `_c` is still required to pass
    @x = x
    @y = y
  end

  private

  attr_reader :x, :y
end
```

### DSL

Alternatively, you can extend a class with `DefInitialize::DSL` and use `def_initialize` method. Note, how close it looks to the native declaration!

```ruby
class Base
  extend DefInitialize::DSL
end

class Circle < Base
  def_initialize("radius")
end

class Rectangle < Base
  def_initialize("length, width")
end
```

### Access control

You can specify level of access for your readers and writers:

```ruby
class Person < Base
  def_initialize("name", readers: :public, writers: :private)
end

# transforms to:

class Person
  def initialize(name)
    @name = name
  end
  
  attr_reader :name

  private

  attr_writer :name
end

```
Allowed values are `:public`, `:private`, `:protected` and `nil`. If value is `nil`, accessors won't be defined at all.

default value for `readers` is `private`, default value for `writers` is `nil`


### What should I do in more complex cases?

Just write plain old `def initialize`.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/antoshalee/def_initialize.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
