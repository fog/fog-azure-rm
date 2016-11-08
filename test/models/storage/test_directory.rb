require File.expand_path '../../test_helper', __dir__

# Test class for Storage Container Model
class TestDirectory < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(storage_account_credentials)
    @directory = mock_storage_directory(@service)

    @container = ApiStub::Models::Storage::Directory.container
    @container_acl = ApiStub::Models::Storage::Directory.container_acl
    @container_https_url = ApiStub::Models::Storage::Directory.container_https_url
  end

  def test_model_methods
    methods = [
      :acl=,
      :acl,
      :destroy,
      :files,
      :public=,
      :public_url,
      :save,
      :persisted?
    ]
    methods.each do |method|
      assert_respond_to @directory, method
    end
  end

  def test_model_attributes
    attributes = [
      :key,
      :etag,
      :last_modified,
      :lease_duration,
      :lease_state,
      :lease_status,
      :metadata
    ]
    @service.stub :create_container, @container do
      attributes.each do |attribute|
        assert_respond_to @directory, attribute
      end
    end
  end

  def test_set_acl_method_success
    result = @directory.acl = 'container'
    assert_equal 'container', result
    assert_equal 'container', @directory.attributes[:acl]
  end

  def test_set_acl_method_exception
    assert_raises(ArgumentError) do
      @directory.acl = 'invalid-acl'
    end
  end

  def test_get_acl_method_success
    # Return 'unknonw' when directory is not persist and acl is 'unknown'
    @directory.acl = 'unknown'
    @directory.stub :persisted?, false do
      assert_equal 'unknown', @directory.acl
    end

    # Return actual value directly when directory is not persist and acl is not 'unknown'
    @directory.acl = 'blob'
    @directory.stub :persisted?, false do
      assert_equal 'blob', @directory.acl
    end

    # Query actual value and return it when directory is persist and acl is 'unknown'
    @directory.acl = 'unknown'
    @directory.stub :persisted?, true do
      @service.stub :get_container_acl, @container_acl do
        assert_equal 'container', @directory.acl
        assert_equal 'container', @directory.attributes[:acl]
      end
    end
  end

  def test_get_acl_method_without_key_exception
    @directory.attributes.delete(:key)
    assert_raises(ArgumentError) do
      @directory.acl
    end
  end

  def test_destroy_method_success
    @service.stub :delete_container, true do
      assert @directory.destroy
    end
  end

  def test_destroy_method_without_key_exception
    @directory.attributes.delete(:key)
    assert_raises(ArgumentError) do
      @directory.destroy
    end
  end

  def test_files_method_success
    assert_instance_of Fog::Storage::AzureRM::Files, @directory.files
  end

  def test_set_public_method_success
    # Set public
    result = @directory.public = true
    assert result
    assert_equal 'container', @directory.attributes[:acl]

    # Set private
    result = @directory.public = false
    assert !result
    assert_equal nil, @directory.attributes[:acl]
  end

  def test_public_url_method_with_public_success
    @directory.stub :acl, 'container' do
      @service.stub :get_container_url, @container_https_url do
        assert_equal @container_https_url, @directory.public_url
      end
    end
  end

  def test_public_url_method_with_private_success
    @directory.stub :acl, nil do
      assert @directory.public_url.nil?
    end
  end

  def test_public_url_method_without_key_exception
    @directory.attributes.delete(:key)
    assert_raises(ArgumentError) do
      @directory.public_url
    end
  end

  def test_save_method_create_success
    @service.stub :create_container, @container do
      assert @directory.save
      assert @directory.attributes[:is_persisted]
    end
  end

  def test_save_method_update_success
    options = { is_create: false }
    @service.stub :put_container_acl, true do
      @service.stub :put_container_metadata, true do
        @service.stub :get_container_properties, @container do
          assert @directory.save(options)
          assert @directory.attributes[:is_persisted]
        end
      end
    end
  end

  def test_save_method_without_key_exception
    @directory.attributes.delete(:key)
    assert_raises(ArgumentError) do
      @directory.save
    end
  end

  def test_persisted_method_success
    @directory.attributes[:is_persisted] = true
    @directory.attributes[:last_modified] = nil
    assert @directory.persisted?

    @directory.attributes[:is_persisted] = false
    @directory.attributes[:last_modified] = 'datetime'
    assert @directory.persisted?

    @directory.attributes[:is_persisted] = false
    @directory.attributes[:last_modified] = nil
    assert !@directory.persisted?
  end
end
