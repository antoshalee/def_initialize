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
      names = parameters
              .map { |p| p[1] }
              .select { |n| n && !n.to_s.start_with?('_') }

      readers = names.map { |a| ":#{a}" }.join(', ')
      body = names.map { |a| "@#{a} = #{a}" }.join("\n")

      module_eval <<-CODE, __FILE__, __LINE__ + 1
        def initialize(#{args_str})
          #{body}
        end

        attr_reader #{readers}
      CODE
    end
  end

  class << self
    def with(args_str)
      Mixin.new(args_str)
    end
  end
end
