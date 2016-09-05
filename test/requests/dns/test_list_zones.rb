require File.expand_path '../../../test_helper', __FILE__

# Test class for List Zones Request
class TestListZones < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = @service.zones
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_list_zones_success
    client = @service.instance_variable_get(:@resources)

    list_resources_response = ApiStub::Requests::Resources::ResourceGroup.list_resource_groups_for_zones
    list_zones_response = ApiStub::Requests::DNS::Zone.list_zones_response

    client.stub :resource_groups, list_resources_response do
      @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
        RestClient.stub :get, list_zones_response do
          assert_equal @service.list_zones, JSON.parse(list_zones_response)['value']
        end
      end
    end
  end

  def test_list_zones_exception
    client = @service.instance_variable_get(:@resources)

    list_resources_response = ApiStub::Requests::Resources::ResourceGroup.list_resource_groups_for_zones
    exception_response = -> { fail Exception.new('mocked exception') }

    client.stub :resource_groups, list_resources_response do
      @token_provider.stub :get_authentication_header, exception_response do
        assert_raises Exception do
          @service.list_zones
        end
      end
    end
  end
end
