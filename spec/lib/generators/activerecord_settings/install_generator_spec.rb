require "generator_spec"

module ActiverecordSettings
  module Generators
    RSpec.describe InstallGenerator, type: :generator do

      root_dir = File.expand_path("../../../../../tmp", __FILE__)
      destination root_dir

      before :all do
        prepare_destination
        run_generator
      end

      it "creates the installation db migration" do
        migration_file = Dir.glob("#{root_dir}/db/migrate/*create_activerecord_settings.rb")

        assert_file migration_file[0], /class CreateActiverecordSettings < ActiveRecord::Migration/
      end
    end
  end
end
