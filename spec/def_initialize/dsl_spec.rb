RSpec.describe DefInitialize::DSL do
  it 'works' do
    klass = Class.new do
      extend DefInitialize::DSL

      def_initialize("name, lastname, age:, position: 'speaker'")
    end

    person = klass.new("Jiddu", "Krishnamurti", age: 75)
    expect(person.name).to eq "Jiddu"
    expect(person.lastname).to eq "Krishnamurti"
    expect(person.position).to eq "speaker"
  end

  it 'works for inherited classes' do
    base = Class.new do
      extend DefInitialize::DSL
    end

    klass = Class.new(base) do
      def_initialize("name, lastname, age:, position: 'speaker'")
    end

    person = klass.new("Jiddu", "Krishnamurti", age: 75)
    expect(person.name).to eq "Jiddu"
    expect(person.lastname).to eq "Krishnamurti"
    expect(person.position).to eq "speaker"
  end
end
