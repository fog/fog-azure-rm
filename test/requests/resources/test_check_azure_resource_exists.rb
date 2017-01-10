require File.expand_path '../../test_helper', __dir__

# Test class for Check Azure Resource Exists Request
class TestCheckAzureResourceExists < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @resources = @client.resources
  end

  def test_tag_resource_success
    @resources.stub :check_existence, true do
        resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
        assert_equal @service.check_azure_resource_exists(resource_id, '2016-09-01'), true
    end
  end

  def test_invalid_resource_id_exeception
    resource_id = 'Invalid-Resource-ID'
    assert_raises(RuntimeError) { @service.check_azure_resource_exists(resource_id, '2016-09-01') }
  end
end
