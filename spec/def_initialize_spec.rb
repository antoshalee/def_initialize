require 'securerandom'

RSpec.describe DefInitialize do
  it 'has a version number' do
    expect(DefInitialize::VERSION).not_to be nil
  end

  let(:klass) do
    str = args_str
    opts = options

    Class.new do
      include DefInitialize.with(str, opts)
    end
  end

  let(:args_str) { "name, uuid = SecureRandom.uuid, age:, position: 'Manager', **data" }
  let(:options) { {} }

  it 'defines initializer, private readers and no writers' do
    expect(klass.private_instance_methods).to include(:name, :uuid, :age, :position, :data)
    expect(klass.private_instance_methods).not_to include(:name=)

    person = klass.new('Olga', age: 25, linkedin: 'link')

    expect(person.send(:name)).to eq 'Olga'
    expect(person.send(:uuid).length).to eq 36
    expect(person.send(:age)).to eq 25
    expect(person.send(:position)).to eq 'Manager'
    expect(person.send(:data)).to eq(linkedin: 'link')

    expect(person).not_to respond_to(:name=)
  end

  context 'with public readers mode' do
    let(:options) { { readers: :public } }

    it 'defines initializer and public accessors' do
      person = klass.new('Olga', age: 25)
      expect(person.name).to eq 'Olga'
    end
  end

  context 'with public writers and private readers' do
    let(:options) { { writers: :public } }

    it 'works' do
      person = klass.new('Olga', age: 25)
      expect(klass.private_instance_methods).to include(:name)

      expect(person.send(:name)).to eq 'Olga'
      person.name = 'Ivan'
      expect(person.send(:name)).to eq 'Ivan'
    end
  end

  context 'with public writers and readers' do
    let(:options) { { writers: :public, readers: :public } }

    it 'defines both accessors' do
      person = klass.new('Olga', age: 25)

      expect(person.name).to eq 'Olga'
      person.name = 'Ivan'
      expect(person.name).to eq 'Ivan'
    end
  end

  context 'without readers' do
    let(:options) { { readers: nil } }

    it 'defines only initializer' do
      person = klass.new('Olga', age: 25, linkedin: 'link')

      expect(person).not_to respond_to(:name)
      expect(klass.private_instance_methods).not_to include(:name)
    end
  end

  context 'with initializer overriding' do
    let(:klass) do
      Class.new do
        include DefInitialize.with("name, uuid = SecureRandom.uuid, age:, position: 'manager'")

        def initialize(*args)
          super

          @age = 50
        end
      end
    end

    it 'adds method to ancestors chain and can be called by #super' do
      person = klass.new 'Olga', age: 35
      expect(person.send(:name)).to eq 'Olga'
      expect(person.send(:age)).to eq 50
    end
  end

  context 'with invalid syntax' do
    let(:args_str) { 'name,,uuid' }

    it 'raises an error on invalid syntax' do
      expect { klass }.to raise_error(SyntaxError)
    end
  end

  context 'with anonimous *rest_params' do
    let(:args_str) { "name, *" }

    it 'allows a variable number of arguments' do
      person = klass.new('Olga')
      expect(person.send(:name)).to eq 'Olga'
      person = klass.new('Olga', 1)
      expect(person.send(:name)).to eq 'Olga'
      person = klass.new('Olga', 1, '2')
      expect(person.send(:name)).to eq 'Olga'
    end
  end

  context 'with anonimous **kwrest_params' do
    let(:args_str) { "name:, **" }

    it 'allows arbitrary hashes that include required fields' do
      person = klass.new(name: 'Olga')
      expect(person.send(:name)).to eq 'Olga'
      person = klass.new(name: 'Olga', lastname: 'Egorova')
      expect(person.send(:name)).to eq 'Olga'
      expect { klass.new(lastname: 'Olga') }.to raise_error(ArgumentError)
    end
  end

  context 'with underscored variable names' do
    let(:args_str) { "x, _, y, _foo, _bar" }

    it 'does not assign them' do
      obj = klass.new(1, 2, 3, 4, 5)
      expect(obj.send(:x)).to eq 1
      expect(obj.send(:y)).to eq 3
      expect(klass.private_instance_methods).not_to include(:_foo, :_bar)
    end
  end
end
