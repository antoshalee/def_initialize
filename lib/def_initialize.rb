require "def_initialize/version"

module DefInitialize
  # Simply parses input string as a method parameter string
  # It raises an exception, If it fails
  # Otherwise returns all argument names including keyword arguments
  class Parser
    VAR_RE    = /(\w+)/
    ARG_RE    = /#{VAR_RE}(?:\s=\s.+?)*/
    ARGS_RE   = /#{ARG_RE}(?:, #{ARG_RE})*/
    KWARG_RE  = /#{VAR_RE}:(?:\s.+?)*/
    KWARGS_RE = /#{KWARG_RE}(?:, #{KWARG_RE})*/
    RE        = /\A#{ARGS_RE}(?:, #{KWARGS_RE})?\z/

    class << self
      def parse(str)
        if(match_data = str.match(RE))
          match_data.captures
        else
          raise ArgumentError, 'Failed to parse arguments'
        end
      end
    end
  end

  class Mixin < Module
    def initialize(args_str)
      args = Parser.parse(args_str)

      readers = args.map { |a| ":#{a}"}.join(", ")

      body = args.reduce(''.dup) do |acc, arg|
        acc << "@#{arg} = #{arg}\n"
      end

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
