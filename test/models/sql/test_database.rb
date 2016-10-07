require File.expand_path '../../test_helper', __dir__

# Test class for Database Model
class TestDatabase < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @database = database(@service)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @database.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :server_name,
      :type,
      :collation,
      :create_mode,
      :creation_date,
      :current_service_level_objective_id,
      :database_id,
      :default_secondary_location,
      :edition,
      :earliest_restore_date,
      :elastic_pool_name,
      :location,
      :max_size_bytes,
      :requested_service_objective_id,
      :requested_service_objective_name,
      :restore_point_in_time,
      :service_level_objective,
      :source_database_id,
      :source_database_deletion_date
    ]
    attributes.each do |attribute|
      assert @database.respond_to? attribute, true
    end
  end

  def test_save_method_response
    create_response = ApiStub::Models::Sql::SqlDatabase.create_database
    @service.stub :create_or_update_database, create_response do
      assert_instance_of Fog::Sql::AzureRM::SqlDatabase, @database.save
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_database, true do
      assert @database.destroy
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_database, false do
      assert !@database.destroy
    end
  end
end
