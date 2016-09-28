require File.expand_path '../../test_helper', __dir__

# Test class for Update VM Extension request
class TestUpdateVMExtension < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @vm_extension = compute_client.virtual_machine_extensions
    @response = ApiStub::Requests::Compute::VirtualMachineExtension.create_vm_extension_response(compute_client)
    @vm_extension_hash = ApiStub::Requests::Compute::VirtualMachineExtension.vm_extension_params
  end

  def test_update_vm_extension_success
    @vm_extension.stub :create_or_update, @response do
      assert_equal @service.add_or_update_vm_extension(@vm_extension_hash), @response
    end
  end

  def test_update_vm_extension_argument_error
    @vm_extension.stub :create_or_update, @response do
      assert_raises ArgumentError do
        @service.add_or_update_vm_extension
      end
    end
  end

  def test_update_vm_extension_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @vm_extension.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.add_or_update_vm_extension(@vm_extension_hash)
      end
    end
  end
end
