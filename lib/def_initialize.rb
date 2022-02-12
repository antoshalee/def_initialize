# frozen_string_literal: true

module DefInitialize
  require 'def_initialize/version'
  require 'def_initialize/dsl'
  require 'def_initialize/accessors_builder'

  class Mixin < Module
    def initialize(*args, readers: :private, writers: nil)
      accessors_options = { readers_access_level: readers, writers_access_level: writers }

      args_str = args.join(', ')

      # Create empty method just to inspect its parameters.
      module_eval <<-CODE, __FILE__, __LINE__ + 1
        def initialize(#{args_str}); end
      CODE

      parameters = instance_method(:initialize).parameters

      accessors, rows = [], []

      parameters
        .each do |(_type, name)|
          next if !name || name.to_s.start_with?('_')
          accessors << ":#{name}"
          rows << "@#{name} = #{name}"
        end

      module_eval <<-CODE, __FILE__, __LINE__ + 1
        def initialize(#{args_str})
          #{rows.join("\n")}
        end

        #{AccessorsBuilder.build(accessors, **accessors_options)}
      CODE
    end
  end

  class << self
    def with(*args, **opts)
      Mixin.new(*args, **opts)
    end
  end
end
