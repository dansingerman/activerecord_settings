require "active_record"
require "activerecord_settings/version"

module ActiverecordSettings
  class Setting < ::ActiveRecord::Base
    self.table_name = "activerecord_settings"

    if ::ActiveRecord::VERSION::MAJOR < 4 || defined?(::ActiveRecord::MassAssignmentSecurity)
      attr_accessible :key, :value, :expires
    end

    def self.get(key)
      setting = find_by_key(key)
      return nil unless setting

      if setting.expires && setting.expires < Time.now
        destroy(key)
        return nil
      end

      YAML.load(setting.value)
    end

    def self.set(key, value, expires: nil)
      destroy(key) if value.nil?

      setting = { value: YAML.dump(value), expires: expires }

      existing = find_by_key(key)

      if existing
        existing.update_attributes(setting)
      else
        create({ key: key }.merge(setting))
      end
    end

    def self.destroy(key)
      find_by_key(key).try(:destroy)
    end
  end
end
