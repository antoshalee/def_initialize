module DefInitialize
  module DSL
    def def_initialize(args_str)
      include(DefInitialize.with(args_str))
    end
  end
end
