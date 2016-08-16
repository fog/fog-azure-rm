require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Machine Request
class TestCreateVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
    @linux_virtual_machine_hash = ApiStub::Requests::Compute::VirtualMachine.linux_virtual_machine_hash
    @windows_virtual_machine_hash = ApiStub::Requests::Compute::VirtualMachine.windows_virtual_machine_hash
  end

  def test_create_linux_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    @promise.stub :value!, response do
      @virtual_machines.stub :create_or_update, @promise do
        assert_equal @service.create_virtual_machine(@linux_virtual_machine_hash),
                     Azure::ARM::Compute::Models::VirtualMachine.serialize_object(response.body)
      end
    end
  end

  def test_create_windows_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    @promise.stub :value!, response do
      @virtual_machines.stub :create_or_update, @promise do
        assert_equal @service.create_virtual_machine(@windows_virtual_machine_hash),
                     Azure::ARM::Compute::Models::VirtualMachine.serialize_object(response.body)
      end
    end
  end

  def test_create_virtual_machine_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_machines.stub :create_or_update, @promise do
        assert_raises Fog::AzureRM::OperationError do
          @service.create_virtual_machine(@linux_virtual_machine_hash)
        end
      end
    end
  end
end
