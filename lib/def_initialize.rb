module DefInitialize
  require 'def_initialize/version'
  require 'def_initialize/parser'
  require 'def_initialize/dsl'

  class Mixin < Module
    def initialize(args_str)
      @args_str = args_str
      @args = Parser.parse(args_str)

      names = @args.map(&:name).compact

      readers = names.map { |a| ":#{a}" }.join(', ')
      body = names.map { |a| "@#{a} = #{a}" }.join("\n")

      module_eval <<-CODE, __FILE__, __LINE__ + 1
        def initialize(#{args_str})
          #{body}
        end

        attr_reader #{readers}
      CODE
    end

    # Expose parsed args for integration with libraries.
    # btw, look at https://github.com/marshall-lee/function_object :)
    attr_reader :args
  end

  class << self
    def with(args_str)
      Mixin.new(args_str)
    end
  end
end
