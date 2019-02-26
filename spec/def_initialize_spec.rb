require 'securerandom'

RSpec.describe DefInitialize do
  it 'has a version number' do
    expect(DefInitialize::VERSION).not_to be nil
  end

  let(:klass) do
    Class.new do
      extend DefInitialize.with("name, lastname = SecureRandom.uuid, age:, position: 'manager'")
    end
  end

  let(:person) { klass.new 'Olga', age: 35 }

  it 'works' do
    expect(person.name).to eq 'Olga'
    expect(person.lastname.length).to eq 36 # UUID length
    expect(person.age).to eq 35
    expect(person.position).to eq 'manager'
  end
end
