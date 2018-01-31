RSpec.describe ActiverecordSettings do
  let(:test_number) { rand 99999 }
  let(:test_string) { test_number.to_s }
  let(:test_object) { { key: test_string } }

  it "Has a version number" do
    expect(ActiverecordSettings::VERSION).not_to be nil
  end

  it "Can set/get a numeric key" do
    ActiverecordSettings::Setting.set('key', test_number)
    expect(ActiverecordSettings::Setting.get('key')).to eq test_number
  end

  it "Can set/get a string key" do
    ActiverecordSettings::Setting.set('key', test_string)
    expect(ActiverecordSettings::Setting.get('key')).to eq test_string
  end

  it "Can set/get an object key" do
    ActiverecordSettings::Setting.set('key', test_object)
    expect(ActiverecordSettings::Setting.get('key')).to eq test_object
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
end
