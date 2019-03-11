module DefInitialize
  module DSL
    def def_initialize(args_str, **opts)
      include(DefInitialize.with(args_str, **opts))
    end
  end
end
