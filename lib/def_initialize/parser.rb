# frozen_string_literal: true

module DefInitialize::Parser
  require 'def_initialize/parser/ripper'

  Arg = Struct.new(:type, :name)

  def self.new(*args)
    # TODO: implement platform-independent parser???
    Ripper.new(*args)
  end

  def self.parse(*args)
    new(*args).parse
  end
end
