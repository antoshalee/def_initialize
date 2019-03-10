# frozen_string_literal: true

module DefInitialize
  require 'def_initialize/version'
  require 'def_initialize/dsl'

  class Mixin < Module
    def initialize(args_str)
      # Create empty method just to inspect its parameters.
      module_eval <<-CODE, __FILE__, __LINE__ + 1
        def initialize(#{args_str}); end
      CODE

      parameters = instance_method(:initialize).parameters

      readers, rows = [], []

      parameters
        .each do |(_type, name)|
          next if !name || name.to_s.start_with?('_')
          readers << ":#{name}"
          rows << "@#{name} = #{name}"
        end

      module_eval <<-CODE, __FILE__, __LINE__ + 1
        def initialize(#{args_str})
          #{rows.join("\n")}
        end

        attr_reader #{readers.join(', ')}
      CODE
    end
  end

  class << self
    def with(args_str)
      Mixin.new(args_str)
    end
  end
end
