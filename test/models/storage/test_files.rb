require File.expand_path '../../test_helper', __dir__

# Test class for Blob Collection
class TestFiles < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @directory = mock_storage_directory(@service)
    @files = @directory.files

    @mocked_response = mocked_storage_http_error
    @container = ApiStub::Models::Storage::File.container
    @blob = ApiStub::Models::Storage::File.blob
    @blob_list = ApiStub::Models::Storage::File.blob_list
    @blob_https_url = ApiStub::Models::Storage::File.blob_https_url
  end

  def test_collection_methods
    methods = [
      :all,
      :each,
      :each_file_this_page,
      :get,
      :get_url,
      :get_http_url,
      :get_https_url,
      :head,
      :new
    ]
    methods.each do |method|
      assert_respond_to @files, method
    end
  end

  def test_collection_attributes
    attributes = [
      :directory,
      :delimiter,
      :marker,
      :max_results,
      :next_marker,
      :prefix
    ]
    attributes.each do |attribute|
      assert_respond_to @files, attribute
    end
  end

  def test_all_method
    @service.stub :get_container_properties, @container do
      @service.stub :list_blobs, @blob_list do
        files = @files.all
        assert_instance_of Fog::Storage::AzureRM::Files, files
        assert_equal @blob_list[:blobs].size, files.size
      end
    end
  end

  def test_all_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.all
    end
  end

  def test_all_method_container_not_found
    @directory.collection.stub :get, nil do
      assert @files.all.nil?
    end
  end

  def test_each_method_with_all
    @blob_list[:next_marker] = nil
    @blob_list[:marker] = nil
    @service.stub :get_container_properties, @container do
      @service.stub :list_blobs, @blob_list do
        @files.next_marker = nil
        j = 0
        @files.each do |file|
          assert_instance_of Fog::Storage::AzureRM::File, file
          j += 1
        end
        assert_equal @blob_list[:blobs].size, j
      end
    end
  end

  def test_each_method_with_parts
    assert_instance_of Fog::Storage::AzureRM::Files, @files.each

    multiple_values = lambda do |_container_name, options|
      if options[:marker] == 'marker'
        return {
          next_marker: nil,
          blobs: @blob_list[:blobs][2, 2]
        }
      end
      return {
        next_marker: 'marker',
        blobs: @blob_list[:blobs][0, 2]
      }
    end

    @service.stub :get_container_properties, @container do
      @service.stub :list_blobs, multiple_values do
        j = 0
        @files.each do |file|
          assert_instance_of Fog::Storage::AzureRM::File, file
          j += 1
        end
        assert_equal @blob_list[:blobs].size, j
      end
    end
  end

  def test_get_method_success
    content = 'data'
    @service.stub :get_blob, [@blob, content] do
      file = @files.get('test_blob')
      assert_instance_of Fog::Storage::AzureRM::File, file
      assert_equal content, file.body
    end
  end

  def test_get_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.get('test_blob')
    end
  end

  def test_get_method_blob_not_found
    exception = ->(*) { raise 'NotFound' }
    @service.stub :get_blob, exception do
      assert @files.get('test_blob').nil?
    end
  end

  def test_get_method_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :get_blob, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @files.get('test_blob')
      end
    end
  end

  def test_get_url_method_success
    @files.stub :get_https_url, @blob_https_url do
      assert_equal @blob_https_url, @files.get_url('test_blob', Time.now + 3600)
    end

    options = { scheme: 'http' }
    http_url = @blob_https_url.gsub('https:', 'http:')
    @files.stub :get_http_url, http_url do
      assert_equal http_url, @files.get_url('test_blob', Time.now + 3600, options)
    end
  end

  def test_get_url_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.get_url('test_blob', Time.now + 3600)
    end
  end

  def test_get_http_url_method_success
    http_url = @blob_https_url.gsub('https:', 'http:')
    @service.stub :get_blob_http_url, http_url do
      assert_equal http_url, @files.get_http_url('test_blob', Time.now + 3600)
    end
  end

  def test_get_http_url_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.get_http_url('test_blob', Time.now + 3600)
    end
  end

  def test_get_https_url_method_success
    @service.stub :get_blob_https_url, @blob_https_url do
      assert_equal @blob_https_url, @files.get_https_url('test_blob', Time.now + 3600)
    end
  end

  def test_get_https_url_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.get_https_url('test_blob', Time.now + 3600)
    end
  end

  def test_head_method_success
    @service.stub :get_blob_properties, @blob do
      file = @files.head('test_blob')
      assert_instance_of Fog::Storage::AzureRM::File, file
      assert file.attributes[:body].nil?
    end
  end

  def test_head_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.head('test_blob')
    end
  end

  def test_head_method_blob_not_found
    exception = ->(*) { raise 'NotFound' }
    @service.stub :get_blob_properties, exception do
      assert @files.head('test_blob').nil?
    end
  end

  def test_head_method_http_exception
    http_exception = ->(*) { raise Azure::Core::Http::HTTPError.new(@mocked_response) }
    @service.stub :get_blob_properties, http_exception do
      assert_raises(Azure::Core::Http::HTTPError) do
        @files.head('test_blob')
      end
    end
  end

  def test_new_method_success
    assert_instance_of Fog::Storage::AzureRM::File, @files.new
  end

  def test_new_method_without_directory_exception
    assert_raises(ArgumentError) do
      @files.attributes.delete(:directory)
      @files.new
    end
  end
end
