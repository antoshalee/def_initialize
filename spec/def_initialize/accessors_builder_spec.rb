RSpec.describe DefInitialize::AccessorsBuilder do
  subject { described_class.build(accessors, options) }

  let(:accessors) { [':x', ':y', ':z'] }

  context 'only readers' do
    let(:options) { { readers_mode: :public, writers_mode: nil } }

    specify do
      is_expected.to eq(<<-STR)
public
attr_reader :x, :y, :z
STR
    end
  end

  context 'both readers and writers' do
    let(:options) { { readers_mode: :public, writers_mode: 'private' } }

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
    let(:options) { { readers_mode: nil, writers_mode: nil } }

    it { is_expected.to eq '' }
  end

  context 'unknown reader mode' do
    let(:options) { { readers_mode: :foo, writers_mode: nil } }

    specify do
      expect { subject }.to raise_error(ArgumentError)
    end
  end

  context 'unknown writer mode' do
    let(:options) { { readers_mode: :private, writers_mode: 'foo' } }

    specify do
      expect { subject }.to raise_error(ArgumentError)
    end
  end
end
