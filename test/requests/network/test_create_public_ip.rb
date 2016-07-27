require File.expand_path '../../test_helper', __dir__

# Test class for Create Public IP Request
class TestCreatePublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @public_ips = client.public_ipaddresses
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_public_ip_success
    mocked_response = ApiStub::Requests::Network::PublicIp.create_public_ip_response
    expected_response = Azure::ARM::Network::Models::PublicIPAddress.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @public_ips.stub :create_or_update, @promise do
        assert_equal @service.create_public_ip('fog-test-rg', 'fog-test-public-ip', 'West US', 'Dynamic'), expected_response
      end
    end
  end

  def test_create_public_ip_argument_error_failure
    response = ApiStub::Requests::Network::PublicIp.create_public_ip_response
    @promise.stub :value!, response do
      @public_ips.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_public_ip('fog-test-rg', 'fog-test-public-ip', 'West US')
        end
      end
    end
  end

  def test_create_public_ip_exception_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @public_ips.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_public_ip('fog-test-rg', 'fog-test-public-ip', 'West US', 'Dynamic')
        end
      end
    end
  end
end
