require File.expand_path '../../test_helper', __dir__

# Storage Container Class
class TestGetContainerUrl < Minitest::Test
  # This class posesses the test cases for the requests of getting storage container url.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @url = ApiStub::Requests::Storage::Directory.container_https_url
  end

  def test_get_container_url_success
    @blob_client.stub :generate_uri, @url do
      assert_equal @url, @service.get_container_url('test_container')

      options = { scheme: 'http' }
      assert_equal @url.gsub('https:', 'http:'), @service.get_container_url('test_container', options)
    end
  end

  def test_get_container_url_mock
    assert_equal @url, @mock_service.get_container_url('test_container')

    options = { scheme: 'http' }
    http_url = @url.gsub('https:', 'http:')
    assert_equal http_url, @mock_service.get_container_url('test_container', options)
  end
end
