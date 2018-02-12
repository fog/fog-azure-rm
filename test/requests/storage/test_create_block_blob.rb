require File.expand_path '../../test_helper', __dir__

# Storage Blob Class
class TestCreateBlockBlob < Minitest::Test
  # This class posesses the test cases for the requests of creating block blob.
  def setup
    Fog.mock!
    @mock_service = Fog::Storage::AzureRM.new(storage_account_credentials)
    Fog.unmock!
    @mocked_response = mocked_storage_http_error

    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @blob_client = @service.instance_variable_get(:@blob_client)

    @block_blob = ApiStub::Requests::Storage::File.block_blob
    @emtpy_block_blob = ApiStub::Requests::Storage::File.emtpy_block_blob
  end

  def test_create_block_blob_success
    @blob_client.stub :create_block_blob, @block_blob do
      assert_equal @block_blob, @service.create_block_blob('test_container', 'test_blob', 'data')
    end
  end

  def test_create_block_blob_without_content_success
    @blob_client.stub :create_block_blob, @emtpy_block_blob do
      assert_equal @emtpy_block_blob, @service.create_block_blob('test_container', 'test_blob', nil)
    end
  end

  def test_create_block_blob_with_file_handle_success
    temp_file = '/dev/null'
    File.open(temp_file, 'r') do |body|
      body.stub :read, 'data' do
        body.stub :rewind, nil do
          @blob_client.stub :create_block_blob, @block_blob do
            assert_equal @block_blob, @service.create_block_blob('test_container', 'test_blob', body)
          end
        end
      end
    end

    exception = ->(*) { raise 'do not support rewind' }
    File.open(temp_file, 'r') do |body|
      body.stub :read, 'data' do
        body.stub :rewind, exception do
          @blob_client.stub :create_block_blob, @block_blob do
            assert_equal @block_blob, @service.create_block_blob('test_container', 'test_blob', body)
          end
        end
      end
    end
  end

  def test_create_block_blob_exceed_max_body_size
    data = []
    data.stub :size, 64 * 1024 * 1024 + 1 do
      assert_raises(ArgumentError) do
        @service.create_block_blob('test_container', 'test_blob', data)
      end
    end
  end

  def test_create_block_blob_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @blob_client.stub :create_block_blob, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @service.create_block_blob('test_container', 'test_blob', nil)
      end
    end
  end

  def test_create_block_blob_mock
    assert_equal @block_blob, @mock_service.create_block_blob('test_container', 'test_blob', 'data')
  end

  def test_create_block_blob_without_content_mock
    assert_equal @emtpy_block_blob, @mock_service.create_block_blob('test_container', 'test_blob', nil)
  end
end
