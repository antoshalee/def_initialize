RSpec.describe DefInitialize::Parser do
  describe "valid strings" do
    [
      "name, lastname",
      "name = 'John', lastname",
      "name, sex:",
      "name, sex: 'female'"
    ].each do |str|
      it "String: #{str}" do
        expect { described_class.parse(str) }.not_to raise_error
      end
    end
  end

  it "parses simple signatures with defaults, keyword args, rest params and blocks" do
    str = "a,b,c='1,2,3',d = SecureRandom.uuid(hahaha.classic[1,2,3]), *e,f,g, x:, y: Wow, z:, **opts, &block"
    expect(described_class.parse(str)).to match [
      an_object_having_attributes(type: :param, name: 'a'),
      an_object_having_attributes(type: :param, name: 'b'),
      an_object_having_attributes(type: :param, name: 'c'),
      an_object_having_attributes(type: :param, name: 'd'),
      an_object_having_attributes(type: :rest_param, name: 'e'),
      an_object_having_attributes(type: :param, name: 'f'),
      an_object_having_attributes(type: :param, name: 'g'),
      an_object_having_attributes(type: :label, name: 'x'),
      an_object_having_attributes(type: :label, name: 'y'),
      an_object_having_attributes(type: :label, name: 'z'),
      an_object_having_attributes(type: :kwrest_param, name: 'opts'),
      an_object_having_attributes(type: :blockarg, name: 'block')
    ]
  end

  it "parses anonimous *rest params" do
    expect(described_class.parse('a,b,*,c')).to match [
      an_object_having_attributes(type: :param, name: 'a'),
      an_object_having_attributes(type: :param, name: 'b'),
      an_object_having_attributes(type: :rest_param, name: nil),
      an_object_having_attributes(type: :param, name: 'c')
    ]
    expect(described_class.parse('a,b,*')).to match [
      an_object_having_attributes(type: :param, name: 'a'),
      an_object_having_attributes(type: :param, name: 'b'),
      an_object_having_attributes(type: :rest_param, name: nil)
    ]
    expect(described_class.parse('*')).to match [
      an_object_having_attributes(type: :rest_param, name: nil)
    ]
  end

  it "parses anonimous *kwrest params" do
    expect(described_class.parse('a,**')).to match [
      an_object_having_attributes(type: :param, name: 'a'),
      an_object_having_attributes(type: :kwrest_param, name: nil)
    ]
    expect(described_class.parse('a:,b:,**')).to match [
      an_object_having_attributes(type: :label, name: 'a'),
      an_object_having_attributes(type: :label, name: 'b'),
      an_object_having_attributes(type: :kwrest_param, name: nil)
    ]
    expect(described_class.parse('**')).to match [
      an_object_having_attributes(type: :kwrest_param, name: nil)
    ]
  end
end
