require File.expand_path '../../test_helper', __dir__

# Test class for Create or Update Virtual Network Request
class TestCreateOrUpdatevirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks

    @subnets = [{
      name: 'fog-subnet',
      resource_group: 'confiz-rg',
      virtual_network_name: 'fog-vnet',
      address_prefix: '10.0.0.0/24',
      network_security_group_id: 'nsg-id',
      route_table_id: 'nsg-id'
    }]

    @tags = { key: 'value' }
  end

  def test_create_or_update_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)

    @virtual_networks.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', ['10.1.0.5', '10.1.0.6'], @subnets, ['10.1.0.0/16', '10.2.0.0/16'], @tags), mocked_response
    end
  end

  def test_create_or_update_virtual_network_success_with_address_prefixes_nil
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)

    @virtual_networks.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', ['10.1.0.5', '10.1.0.6'], @subnets, nil, @tags), mocked_response
    end
  end

  def test_create_or_update_virtual_network_argument_error_failure
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)

    @virtual_networks.stub :create_or_update, mocked_response do
      assert_raises ArgumentError do
        @service.create_or_update_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', '10.1.0.0/24', ['10.1.0.5', '10.1.0.6'])
      end
    end
  end

  def test_create_or_update_virtual_network_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }

    @virtual_networks.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_virtual_network('fog-test-rg', 'fog-test-virtual-network', 'westus', ['10.1.0.5', '10.1.0.6'], @subnets, ['10.1.0.0/16', '10.2.0.0/16'], @tags)
      end
    end
  end
end
