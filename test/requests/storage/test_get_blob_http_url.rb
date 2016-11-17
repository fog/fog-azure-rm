require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestGetBlobHttpUrl < Minitest::Test
  # This class posesses the test cases for the requests of Blob service.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
    @signature_client = @service.instance_variable_get(:@signature_client)

    @url = ApiStub::Requests::Storage::File.blob_https_url.gsub('https:', 'http:')
    @token = ApiStub::Requests::Storage::File.blob_url_token
  end

  def test_get_blob_http_url_success
    @blob_client.stub :generate_uri, @url do
      @signature_client.stub :generate_service_sas_token, @token do
        assert_equal "#{@url}?#{@token}", @service.get_blob_http_url('test_container', 'test_blob', Time.now.utc + 3600)
      end
    end
  end

  def test_get_blob_http_url_mock
    assert_equal "#{@url}?#{@token}", @mock_service.get_blob_http_url('test_container', 'test_blob', Time.now.utc + 3600)
  end
end
