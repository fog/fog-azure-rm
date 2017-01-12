require File.expand_path '../../test_helper', __dir__

# Test class for PublicIp Collection
class TestPublicIps < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @public_ips = Fog::Network::AzureRM::PublicIps.new(resource_group: 'fog-test-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
    @response = [ApiStub::Models::Network::PublicIp.create_public_ip_response(@network_client)]
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_public_ip_exists
    ]
    methods.each do |method|
      assert_respond_to @public_ips, method
    end
  end

  def test_collection_attributes
    assert_respond_to @public_ips, :resource_group
  end

  def test_all_method_response
    @service.stub :list_public_ips, @response do
      assert_instance_of Fog::Network::AzureRM::PublicIps, @public_ips.all
      assert @public_ips.all.size >= 1
      @public_ips.all.each do |pip|
        assert_instance_of Fog::Network::AzureRM::PublicIp, pip
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::PublicIp.create_public_ip_response(@network_client)
    @service.stub :get_public_ip, response do
      assert_instance_of Fog::Network::AzureRM::PublicIp, @public_ips.get('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_check_public_ip_exists_method_success
    @service.stub :check_public_ip_exists, true do
      assert @public_ips.check_public_ip_exists('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_check_if_exists_method_failure
    @service.stub :check_public_ip_exists, false do
      assert !@public_ips.check_public_ip_exists('fog-test-rg', 'fog-test-public-ip')
    end
  end
end
