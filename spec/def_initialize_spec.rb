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

  it 'raises an error on invalid syntax' do
    expect do
      Class.new do
        include DefInitialize.with("name,,lastname")
      end
    end.to raise_error(SyntaxError)
  end

  context 'with anonimous *rest_params' do
    let(:klass) do
      Class.new do
        include DefInitialize.with("name, *")
      end
    end

    it 'allows a variable number of arguments' do
      person = klass.new('Olga')
      expect(person.name).to eq 'Olga'
      person = klass.new('Olga', 1)
      expect(person.name).to eq 'Olga'
      person = klass.new('Olga', 1, '2')
      expect(person.name).to eq 'Olga'
    end
  end

  context 'with anonimous **kwrest_params' do
    let(:klass) do
      Class.new do
        include DefInitialize.with("name:, **")
      end
    end

    it 'allows arbitrary hashes that include required fields' do
      person = klass.new(name: 'Olga')
      expect(person.name).to eq 'Olga'
      person = klass.new(name: 'Olga', lastname: 'Egorova')
      expect(person.name).to eq 'Olga'
      expect { klass.new(lastname: 'Olga') }.to raise_error(ArgumentError)
    end
  end

  context 'with underscored variable names' do
    let(:klass) do
      Class.new do
        include DefInitialize.with("x, _, y, _foo, _bar")
      end
    end

    it 'does not assign them' do
      obj = klass.new(1, 2, 3, 4, 5)
      expect(obj.x).to eq 1
      expect(obj.y).to eq 3
      expect(obj).not_to respond_to(:_foo)
      expect(obj).not_to respond_to(:_bar)
    end
  end
end
