require File.expand_path '../../test_helper', __dir__

class TestVirtualMachineExtensions < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @vm_extensions = Fog::Compute::AzureRM::VirtualMachineExtensions.new(resource_group: 'fog-test-rg', service: @service)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @response = ApiStub::Models::Compute::VirtualMachineExtension.create_vm_extension_response(@compute_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_vm_extension_exists?
    ]
    methods.each do |method|
      assert_respond_to @vm_extensions, method
    end
  end

  def test_collection_attributes
    attributes = [
      :resource_group,
      :vm_name
    ]
    attributes.each do |attribute|
      assert_respond_to @vm_extensions, attribute
    end
  end

  def test_get_method_response
    @service.stub :get_vm_extension, @response do
      assert_instance_of Fog::Compute::AzureRM::VirtualMachineExtension, @vm_extensions.get('fog-test-rg', 'fog-test-server', 'fog-test-extension')
    end
  end

  def test_check_vm_extension_exists_true_case
    @service.stub :check_vm_extension_exists?, true do
      assert @vm_extensions.check_vm_extension_exists?('fog-test-rg', 'fog-test-server', 'fog-test-extension')
    end
  end

  def test_check_vm_extension_exists_false_case
    @service.stub :check_vm_extension_exists?, false do
      assert !@vm_extensions.check_vm_extension_exists?('fog-test-rg', 'fog-test-server', 'fog-test-extension')
    end
  end
end
