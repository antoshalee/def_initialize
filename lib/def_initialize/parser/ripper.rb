# frozen_string_literal: true

require 'ripper'

module DefInitialize::Parser
  class Ripper < ::Ripper
    def initialize(args)
      super("def initialize (#{args}); end")
    end

    def parse
      @args = []
      super
      @args
    end

    private

    def on_ident(name)
      [:var, name.to_s]
    end

    def on_label(name)
      [:var, name.to_s[0..-2]]
    end

    def on_rest_param(name)
      name = name[1] if name.is_a?(Array) && name[0] == :var
      [:var, name]
    end

    def on_kwrest_param(name)
      name = name[1] if name.is_a?(Array) && name[0] == :var
      [:var, name]
    end

    def on_params(*params)
      var_name = proc { |ident| ident[1] }

      # 0. required params
      names = Array(params.shift).map(&var_name)

      # 1. params with defaults
      names.concat(Array(params.shift).map(&:first).map!(&var_name))

      @args.concat(names.map { |n| Arg.new(:param, n) })

      # 2. *rest param
      rest = params.shift
      if rest
        name = var_name[rest] if rest.is_a?(Array) && rest[0] == :var
        @args << Arg.new(:rest_param, name)
      end

      # 3. captured params from the tail of the *rest
      names = Array(params.shift).map(&var_name)
      @args.concat(names.map { |n| Arg.new(:param, n) })

      # 4. keyword args
      names = Array(params.shift).map(&:first).map!(&var_name)
      @args.concat(names.map { |n| Arg.new(:label, n) })

      # 5. **kwrest param
      kwrest = params.shift
      if kwrest
        name = var_name[kwrest] if kwrest.is_a?(Array) && kwrest[0] == :var
        @args << Arg.new(:kwrest_param, name)
      end

      # 6. &blockarg param
      blockarg = params.shift
      if blockarg
        @args << Arg.new(:blockarg, var_name[blockarg])
      end
    end
  end
end
