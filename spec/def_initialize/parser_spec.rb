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
end
