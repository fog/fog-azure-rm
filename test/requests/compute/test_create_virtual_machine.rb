require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Machine Request
class TestCreateVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    @promise.stub :value!, response do
      @virtual_machines.stub :create_or_update, @promise do
        assert_equal @service.create_virtual_machine('fog-test-rg', 'fog-test-server', 'westus', 'Basic_A0',
                                                     'fogstrg', 'fog', 'fog', false, '/home', 'key', 'nic-id',
                                                     'as-id', 'Canonical', 'UbuntuServer', '14.04.2-LTS', 'latest'),
                     Azure::ARM::Compute::Models::VirtualMachine.serialize_object(response.body)
      end
    end
  end

  def test_create_virtual_machine_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_machines.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_virtual_machine('fog-test-rg', 'fog-test-server', 'westus', 'Basic_A0', 'fogstrg', 'fog',
                                          'fog', false, '/home', 'key', 'nic-id', 'as-id', 'Canonical',
                                          'UbuntuServer', '14.04.2-LTS', 'latest')
        end
      end
    end
  end
end
