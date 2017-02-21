require File.expand_path '../../test_helper', __dir__

# Test class for Managed Disk Collection
class TestManagedDisks < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @managed_disks = Fog::Compute::AzureRM::ManagedDisks.new(resource_group: 'fog-test-rg', service: @service)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @managed_disk_list = [ApiStub::Models::Compute::ManagedDisk.create_managed_disk_response(@client)]
    @managed_disk = ApiStub::Models::Compute::ManagedDisk.create_managed_disk_response(@client)
  end

  def test_collection_methods
    methods = [
        :all,
        :get,
        :check_managed_disk_exists
    ]
    methods.each do |method|
      assert_respond_to @managed_disks, method
    end
  end

  def test_collection_attributes
    assert_respond_to @managed_disks, :resource_group
  end

  def test_all_method_response
    @service.stub :list_managed_disks_by_rg, @managed_disk_list do
      assert_instance_of Fog::Compute::AzureRM::ManagedDisks, @managed_disks.all
      assert @managed_disks.all.size >= 1
      @managed_disks.all.each do |disk|
        assert_instance_of Fog::Compute::AzureRM::ManagedDisk, disk
      end
    end
  end

  def test_get_method_response
    @service.stub :get_managed_disk, @managed_disk do
      assert_instance_of Fog::Compute::AzureRM::ManagedDisk, @managed_disks.get('fog-test-rg', 'fog-test-managed_disk')
    end
  end

  def test_check_managed_disk_exists_true_case
    @service.stub :check_managed_disk_exists, true do
      assert @managed_disks.check_managed_disk_exists('fog-test-rg', 'fog-test-managed_disk')
    end
  end

  def test_check_managed_disk_exists_false_case
    @service.stub :check_managed_disk_exists, false do
      assert !@managed_disks.check_managed_disk_exists('fog-test-rg', 'fog-test-managed_disk')
    end
  end

  def test_grant_access_response
    @service.stub :grant_access_to_managed_disk, 'DUMMY-URI' do
      assert_equal(@managed_disks.grant_access('fog-test-rg', 'fog-test-managed_disk', 'Read', 100), 'DUMMY-URI')
    end
  end

  def test_revoke_access_response
    response = ApiStub::Models::Compute::ManagedDisk.operation_status_response(@client)
    @service.stub :revoke_access_to_managed_disk, response do
      assert_equal(@managed_disks.revoke_access('fog-test-rg', 'fog-test-managed_disk').status, 'success')
    end
  end
end
