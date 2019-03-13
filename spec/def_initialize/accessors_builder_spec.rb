RSpec.describe DefInitialize::AccessorsBuilder do
  subject { described_class.build(accessors, options) }

  let(:accessors) { [':x', ':y', ':z'] }

  context 'only readers' do
    let(:options) { { readers_access_level: :public, writers_access_level: nil } }

    specify do
      is_expected.to eq(<<-STR)
public
attr_reader :x, :y, :z
STR
    end
  end

  context 'both readers and writers' do
    let(:options) { { readers_access_level: :public, writers_access_level: 'private' } }

    specify do
      is_expected.to eq(<<-STR)
public
attr_reader :x, :y, :z
private
attr_writer :x, :y, :z
STR
    end
  end

  context 'without accessors at all' do
    let(:options) { { readers_access_level: nil, writers_access_level: nil } }

    it { is_expected.to eq '' }
  end

  context 'unknown reader mode' do
    let(:options) { { readers_access_level: :foo, writers_access_level: nil } }

    specify do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'unknown writer mode' do
    let(:options) { { readers_access_level: :private, writers_access_level: 'foo' } }

    specify do
      expect { subject }.to raise_error(ArgumentError)
    end
  end
end
