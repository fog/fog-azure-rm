require File.expand_path '../../test_helper', __dir__

# Test class for Managed Disk Model
class TestManagedDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @managed_disk = managed_disk(@service)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @response = ApiStub::Models::Compute::ManagedDisk.create_managed_disk_response(compute_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @managed_disk, method
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :type,
      :location,
      :resource_group_name,
      :account_type,
      :time_created,
      :os_type,
      :disk_size_gb,
      :owner_id,
      :provisioning_state,
      :tags,
      :creation_data,
      :encryption_settings,
      :tags
    ]
    attributes.each do |attribute|
      assert_respond_to @managed_disk, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_or_update_managed_disk, @response do
      assert_instance_of Fog::Compute::AzureRM::ManagedDisk, @managed_disk.save
    end
  end

  def test_destroy_method_true_response
    @service.stub :delete_managed_disk, true do
      assert @managed_disk.destroy(false)
    end
  end

  def test_destroy_method_false_response
    @service.stub :delete_managed_disk, false do
      assert !@managed_disk.destroy(false)
    end
  end

  def test_destroy_method_can_take_params_async
    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :delete_managed_disk, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @managed_disk.destroy(true)
    end
  end

  def test_destroy_method_can_take_params_async
    @service.stub :delete_managed_disk, true do
      assert @managed_disk.destroy(true)
    end
  end
end
