require File.expand_path '../../test_helper', __dir__

# Test class for Add Security Rules
class TestAddSecurityRules < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_groups = client.network_security_groups
  end

  def test_add_security_rules_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response
    expected_response_json = ApiStub::Requests::Network::NetworkSecurityGroup.add_security_rules_response
    expected_response = Azure::ARM::Network::Models::NetworkSecurityGroup.serialize_object(expected_response_json.body)
    security_rule =
      {
        name: 'testRule',
        protocol: 'tcp',
        source_port_range: '22',
        destination_port_range: '22',
        source_address_prefix: '0.0.0.0/0',
        destination_address_prefix: '0.0.0.0/0',
        access: 'Allow',
        priority: '100',
        direction: 'Inbound',
        description: 'This is a test rule'
      }

    get_promise = Concurrent::Promise.execute do
    end
    create_promise = Concurrent::Promise.execute do
    end

    get_promise .stub :value!, mocked_response do
      @network_security_groups.stub :get, get_promise do
        create_promise .stub :value!, expected_response_json do
          @network_security_groups.stub :begin_create_or_update, create_promise do
            assert_equal @service.add_security_rules('fog-test-rg', 'fog-test-nsg', [security_rule]), expected_response
          end
        end
      end
    end
  end

  def test_add_security_rules_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    get_promise = Concurrent::Promise.execute do
    end
    create_promise = Concurrent::Promise.execute do
    end
    get_promise.stub :value!, response do
      @network_security_groups.stub :get, get_promise do
        create_promise.stub :value!, response do
          @network_security_groups.stub :begin_create_or_update, create_promise do
            assert_raises MsRestAzure::AzureOperationError do
              @service.add_security_rules('fog-test-rg', 'fog-test-nsg', [])
            end
          end
        end
      end
    end
  end
end
