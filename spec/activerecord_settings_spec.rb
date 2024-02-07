RSpec.describe ActiverecordSettings do
  let(:test_number) { rand 99999 }
  let(:test_string) { test_number.to_s }
  let(:test_object) { { key: test_string } }

  it "Has a version number" do
    expect(ActiverecordSettings::VERSION).not_to be nil
  end

  it "Can destroy a key" do
    ActiverecordSettings::Setting.set('key', test_object)
    expect(ActiverecordSettings::Setting.get('key')).to eq test_object
    ActiverecordSettings::Setting.destroy('key')
    expect(ActiverecordSettings::Setting.get('key')).to eq nil
  end

  it "Can set a key with an expiry" do
    ActiverecordSettings::Setting.set('key', test_object, expires: Time.now + 1.day)
    expect(ActiverecordSettings::Setting.get('key')).to eq test_object

    Timecop.freeze(Date.today + 2) do
      expect(ActiverecordSettings::Setting.get('key')).to eq nil
    end
  end

  context 'When default classes are used' do
    it "Can set/get a numeric key" do
      ActiverecordSettings::Setting.set('key', test_number)
      expect(ActiverecordSettings::Setting.get('key')).to eq test_number
    end

    it "Can set/get a string key" do
      ActiverecordSettings::Setting.set('key', test_string)
      expect(ActiverecordSettings::Setting.get('key')).to eq test_string
    end

    it "Can set/get a hash key" do
      ActiverecordSettings::Setting.set('key', test_object)
      expect(ActiverecordSettings::Setting.get('key')).to eq test_object
    end
  end

  describe 'When running ruby less than 3.1', if: Gem::Version.new(RUBY_VERSION) <= Gem::Version.new('3.1') do
    let!(:datetime_object) { DateTime.now }

    context 'It allows unsafe yaml loading' do
      it 'can set/get a DateTime key' do
        ActiverecordSettings::Setting.set('key', datetime_object)
        expect(ActiverecordSettings::Setting.get('key')).to eq datetime_object
      end
    end
  end

  describe 'When running ruby 3.1+', if: Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1') do
    context 'When non permitted classes are used' do
      it 'Raises a Psych::DisallowedClass error' do
        time = DateTime.now
        ActiverecordSettings::Setting.set('key', time)

        expect {
          ActiverecordSettings::Setting.get('key')
        }.to raise_error(Psych::DisallowedClass)
      end
    end

    context 'When active record has a permitted classes setting' do
      let!(:datetime_object) { DateTime.now }

      before do
        allow(ActiveRecord).to receive(:yaml_column_permitted_classes).and_return([DateTime, Time])
      end

      it 'Does not raise a Psych::DisallowedClass error' do
        ActiverecordSettings::Setting.set('key', datetime_object)

        expect {
          ActiverecordSettings::Setting.get('key')
        }.to_not raise_error
      end

      it 'can set/get a DateTime key' do
        ActiverecordSettings::Setting.set('key', datetime_object)
        expect(ActiverecordSettings::Setting.get('key')).to eq datetime_object
      end
    end

    context 'When active record has a use_yaml_unsafe_load setting' do
      let!(:datetime_object) { DateTime.now }

      before do
        allow(ActiveRecord).to receive(:use_yaml_unsafe_load).and_return(true)
      end

      it 'Does not raise an error' do
        ActiverecordSettings::Setting.set('key', datetime_object)

        expect {
          ActiverecordSettings::Setting.get('key')
        }.to_not raise_error
      end

      it 'can set/get a DateTime key' do
        ActiverecordSettings::Setting.set('key', datetime_object)
        expect(ActiverecordSettings::Setting.get('key')).to eq datetime_object
      end
    end
  end
end
