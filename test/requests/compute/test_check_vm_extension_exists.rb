require File.expand_path '../../test_helper', __dir__

# Test class for Check VM Extension Exists request
class TestCheckVMExtensionExists < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @vm_extension = @compute_client.virtual_machine_extensions
  end

  def test_check_vm_extension_exists_success
    response = ApiStub::Requests::Compute::VirtualMachineExtension.create_vm_extension_response(@compute_client)
    @vm_extension.stub :get, response do
      assert @service.check_vm_extension_exists('fog-test-rg', 'fog-test-vm', 'fog-test-extension')
    end
  end

  def test_check_vm_extension_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @vm_extension.stub :get, response do
      assert !@service.check_vm_extension_exists('fog-test-rg', 'fog-test-vm', 'fog-test-extension')
    end
  end

  def test_check_vm_extension_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @vm_extension.stub :get, response do
      assert !@service.check_vm_extension_exists('fog-test-rg', 'fog-test-vm', 'fog-test-extension')
    end
  end
end
