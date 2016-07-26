require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Network Request
class TestCreateVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @virtual_networks = client.virtual_networks
    @promise = Concurrent::Promise.execute do
    end
    @subnets = [{
      name: 'fog-subnet',
      resource_group: 'confiz-rg',
      virtual_network_name: 'fog-vnet',
      address_prefix: '10.0.0.0/24',
      network_security_group_id: 'nsg-id',
      route_table_id: 'nsg-id'
    }]
  end

  def test_create_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response
    expected_response = Azure::ARM::Network::Models::VirtualNetwork.serialize_object(mocked_response.body)

    @promise.stub :value!, mocked_response do
      @virtual_networks.stub :create_or_update, @promise do
        assert_equal @service.create_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', ['10.1.0.5', '10.1.0.6'], @subnets, ['10.1.0.0/16', '10.2.0.0/16']), expected_response
      end
    end
  end

  def test_create_virtual_network_success_with_address_prefixes_nil
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response
    expected_response = Azure::ARM::Network::Models::VirtualNetwork.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @virtual_networks.stub :create_or_update, @promise do
        assert_equal @service.create_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', ['10.1.0.5', '10.1.0.6'], @subnets, nil), expected_response
      end
    end
  end

  def test_create_virtual_network_argument_error_failure
    response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response
    @promise.stub :value!, response do
      @virtual_networks.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', '10.1.0.0/24', ['10.1.0.5', '10.1.0.6'])
        end
      end
    end
  end

  def test_create_virtual_network_exception_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_networks.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', ['10.1.0.5', '10.1.0.6'], @subnets, ['10.1.0.0/16', '10.2.0.0/16'])
        end
      end
    end
  end
end
