require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCommitBlobBlocks < Minitest::Test
  # This class posesses the test cases for the requests of committing blob blocks.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)
  end

  def test_commit_blob_blocks_success
    @blob_client.stub :commit_blob_blocks, true do
      assert @service.commit_blob_blocks('test_container', 'test_blob', [])
    end
  end

  def test_commit_blob_blocks_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :commit_blob_blocks, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.commit_blob_blocks('test_container', 'test_blob', [])
      end
    end
  end

  def test_commit_blob_blocks_mock
    assert @mock_service.commit_blob_blocks('test_container', 'test_blob', [])
  end
end
