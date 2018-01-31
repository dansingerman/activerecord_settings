# frozen_string_literal: true

require "rails/generators"
require "rails/generators/migration"

module ActiverecordSettings
  module Generators
    # Installs ActiverecordSettings in a rails app.
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      class_option :auto_run_migrations, type: :boolean, default: false

      def self.next_migration_number(path)
        next_migration_number = current_migration_number(path) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def add_migrations
        template = "create_activerecord_settings"
        migration_dir = File.expand_path("db/migrate")
        if self.class.migration_exists?(migration_dir, template)
          ::Kernel.warn "Migration already exists: #{template}"
        else
          migration_template(
            "#{template}.rb.erb",
            "db/migrate/#{template}.rb",
            migration_version: migration_version
          )
        end
      end

      def run_migrations
        return if ENV["RAILS_ENV"] == 'test'
        run_migrations = options[:auto_run_migrations] || ['y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      protected

      def migration_version
        major = ActiveRecord::VERSION::MAJOR
        if major >= 5
          "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
        end
      end
    end
  end
end
