require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestGetBlob < Minitest::Test
  # This class posesses the test cases for the requests of getting storage blob.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @raw_cloud_blob = mock_storage_blob
    @blob = ApiStub::Requests::Storage::File.blob
    @blob_with_content = [
      @blob,
      'content'
    ]
  end

  def test_get_blob_success
    @blob_client.stub :get_blob, @blob_with_content do
      assert_equal @blob_with_content, @service.get_blob('test_container', 'test_blob')
    end
  end

  def test_get_blob_not_found
    exception = ->(*) { raise StandardError.new('Not found(404). Not exist') }
    @blob_client.stub :get_blob, exception do
      assert_raises('NotFound') do
        assert @service.get_blob('test_container', 'test_blob')
      end
    end
  end

  def test_get_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob, http_exception do
      assert_raises(RuntimeError) do
        @service.get_blob('test_container', 'test_blob')
      end
    end
  end

  def test_get_blob_mock
    assert_equal @blob_with_content, @mock_service.get_blob('test_container', 'test_blob')
  end

  def test_get_blob_with_block_given_success
    data = ''
    @blob_client.stub :get_blob_properties, @raw_cloud_blob do
      @blob_client.stub :get_blob, @blob_with_content do
        @service.get_blob('test_container', 'test_blob') do |chunk, _remaining_bytes, _total_bytes|
          data << chunk
        end
        assert_equal @blob_with_content[1], data
      end
    end
  end

  def test_get_blob_with_block_given_with_emtpy_blob_success
    data = ''
    empty_raw_cloud_blob = @raw_cloud_blob
    empty_raw_cloud_blob.properties[:content_length] = 0
    empty_blob_with_content = [
      @blob,
      ''
    ]
    @blob_client.stub :get_blob_properties, empty_raw_cloud_blob do
      @blob_client.stub :get_blob, empty_blob_with_content do
        @service.get_blob('test_container', 'test_blob') do |chunk, _remaining_bytes, _total_bytes|
          data << chunk
        end
        assert data.empty?
      end
    end
  end

  def test_get_blob_with_block_given_with_emtpy_range_success
    data = ''
    options = {
      start_range: 1024,
      end_range: 1024
    }
    @blob_client.stub :get_blob_properties, @raw_cloud_blob do
      @blob_client.stub :get_blob, @blob_with_content do
        @service.get_blob('test_container', 'test_blob', options) do |chunk, _remaining_bytes, _total_bytes|
          data << chunk
        end
        assert data.empty?
      end
    end
  end

  def test_get_blob_with_block_given_invalid_options
    options = {
      start_range: 1024,
      end_range: 0
    }
    @blob_client.stub :get_blob_properties, @raw_cloud_blob do
      @service.stub :get_blob_properties, @blob_with_content[0] do
        assert_raises(ArgumentError) do
          @service.get_blob('test_container', 'test_blob', options) do |*chunk|
          end
        end
      end
    end
  end

  def test_get_blob_with_block_given_not_exist
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob_properties, http_exception do
      assert_raises(RuntimeError) do
        @service.get_blob('test_container', 'test_blob') do |*chunk|
        end
      end
    end
  end

  def test_get_blob_with_block_given_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :get_blob_properties, @raw_cloud_blob do
      @blob_client.stub :get_blob, http_exception do
        assert_raises(RuntimeError) do
          @service.get_blob('test_container', 'test_blob') do |*chunk|
          end
        end
      end
    end
  end

  def test_get_blob_with_block_given_mock
    data = ''
    @mock_service.get_blob('test_container', 'test_blob') do |chunk, _remaining_bytes, _total_bytes|
      data << chunk
    end
    assert_equal @blob_with_content[1], data
  end
end
