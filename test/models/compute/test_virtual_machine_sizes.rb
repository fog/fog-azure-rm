require File.expand_path '../../test_helper', __dir__
# Test class for Managed Disk Collection
class TestVirtualMachineSizes < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @virtual_machine_sizes = Fog::Compute::AzureRM::VirtualMachineSizes.new(location: 'location', service: @service)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @response = ApiStub::Models::Compute::VirtualMachineSize.virtual_machine_sizes(@compute_client)
  end

  def test_collection_attributes
    assert_respond_to @virtual_machine_sizes, :location
  end

  def test_collection_methods
    methods = %i(all)
    methods.each do |method|
      assert_respond_to @virtual_machine_sizes, method
    end
  end

  def test_all_method_response
    @service.stub :list_virtual_machine_sizes, @response do
      sizes = @virtual_machine_sizes.all

      assert_instance_of Fog::Compute::AzureRM::VirtualMachineSizes, sizes
      assert sizes.size >= 1
      sizes.each do |size|
        assert_instance_of Fog::Compute::AzureRM::VirtualMachineSize, size
      end
    end
  end
end
