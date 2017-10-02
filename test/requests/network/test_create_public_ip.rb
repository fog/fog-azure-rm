require File.expand_path '../../test_helper', __dir__

# Test class for Create Public IP Request
class TestCreatePublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @public_ips = @network_client.public_ipaddresses
    @tags = { key: 'value' }
  end

  def test_create_public_ip_success
    mocked_response = ApiStub::Requests::Network::PublicIp.create_public_ip_response(@network_client)
    @public_ips.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_public_ip('fog-test-rg', 'fog-test-public-ip', 'West US', 'Dynamic', '', '', @tags), mocked_response
    end
  end

  def test_create_public_ip_argument_error_failure
    mocked_response = ApiStub::Requests::Network::PublicIp.create_public_ip_response(@network_client)
    @public_ips.stub :create_or_update, mocked_response do
      assert_raises ArgumentError do
        @service.create_or_update_public_ip('fog-test-rg', 'fog-test-public-ip', 'West US')
      end
    end
  end

  def test_create_public_ip_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @public_ips.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_public_ip('fog-test-rg', 'fog-test-public-ip', 'West US', 'Dynamic', '', '', @tags)
      end
    end
  end
end
