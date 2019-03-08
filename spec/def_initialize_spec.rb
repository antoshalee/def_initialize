require 'securerandom'

RSpec.describe DefInitialize do
  it 'has a version number' do
    expect(DefInitialize::VERSION).not_to be nil
  end

  let(:klass) do
    Class.new do
      include DefInitialize.with("name, lastname = SecureRandom.uuid, age:, position: 'manager'")
    end
  end

  let(:person) { klass.new 'Olga', age: 35 }

  it 'works' do
    expect(person.name).to eq 'Olga'
    expect(person.lastname.length).to eq 36 # UUID length
    expect(person.age).to eq 35
    expect(person.position).to eq 'manager'
  end

  context 'with overriding' do
    let(:klass) do
      Class.new do
        include DefInitialize.with("name, lastname = SecureRandom.uuid, age:, position: 'manager'")

        def initialize(*args)
          super

          @age = 50
        end
      end
    end

    it 'adds method to ancestors chain and can be called by #super' do
      expect(person.name).to eq 'Olga'
      expect(person.age).to eq 50
    end
  end
end
