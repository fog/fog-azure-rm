require File.expand_path '../../test_helper', __dir__

# Test class for Managed Disk Collection
class TestSnapshots < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @snapshots = Fog::Compute::AzureRM::Snapshots.new(resource_group: 'fog-test-rg', service: @service)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
  end

  def test_collection_attributes
    assert_respond_to @snapshots, :resource_group
  end
end
