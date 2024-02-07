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

      # Newer versions of Rails 5.2.8.1+ have a setting to allow for permitted classes in YAML columns
      # This is to prevent arbitrary code execution when loading YAML from the database.
      if ActiveRecord.try(:use_yaml_unsafe_load) && YAML.respond_to?(:unsafe_load)
        YAML.unsafe_load(setting.value)
      elsif ActiveRecord.respond_to?(:yaml_column_permitted_classes)
        YAML.safe_load(setting.value, permitted_classes: ActiveRecord.yaml_column_permitted_classes)
      else
        YAML.load(setting.value)
      end
    end

    def self.set(key, value, expires: nil)
      destroy(key) if value.nil?

      setting = { value: YAML.dump(value), expires: expires }

      existing = find_by_key(key)

      if existing
        existing.update(setting)
      else
        create({ key: key }.merge(setting))
      end
    end

    def self.destroy(key)
      find_by_key(key).try(:destroy)
    end
  end
end
