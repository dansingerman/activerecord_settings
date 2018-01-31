require "bundler/setup"
require "timecop"
require "activerecord_settings"
require "generators/activerecord_settings/install_generator"

ENV["RAILS_ENV"] = "test"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

db_adapter = "sqlite3"
config = YAML.load(File.read("spec/database.yml"))
ActiveRecord::Base.establish_connection config[db_adapter]
ActiveRecord::Migration.verbose = false

migration_template = File.open("lib/generators/activerecord_settings/templates/create_activerecord_settings.rb.erb")

# need to eval the template with the migration_version intact
migration_context = Class.new do
  def get_binding
    binding
  end

  private

  def migration_version
    if ActiveRecord::VERSION::MAJOR >= 5
      "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
    end
  end
end

migration_ruby = ERB.new(migration_template.read).result(migration_context.new.get_binding)
eval(migration_ruby)

ActiveRecord::Schema.define do
  CreateActiverecordSettings.migrate(:up)
end
