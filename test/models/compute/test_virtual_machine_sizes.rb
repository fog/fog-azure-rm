require File.expand_path '../../test_helper', __dir__
# Test class for Managed Disk Collection
class TestVirtualMachineSizes < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @virtual_machine_sizes = Fog::Compute::AzureRM::VirtualMachineSizes.new(location: 'location', service: @service)
  end

  def test_collection_attributes
    assert_respond_to @virtual_machine_sizes, :location
  end
end
