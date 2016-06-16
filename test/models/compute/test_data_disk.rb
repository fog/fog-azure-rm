require File.expand_path '../../test_helper', __dir__

# Test class for Data Disk Model
class TestDataDisk < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @data_disk = Fog::Compute::AzureRM::DataDisk.new
  end

  def test_model_attributes
    attributes = [
      :name,
      :disk_size_gb,
      :lun,
      :vhd_uri,
      :caching,
      :create_option
    ]
    attributes.each do |attribute|
      assert @data_disk.respond_to? attribute, true
    end
  end

  def test_parse_method_response
    mocked_response = ApiStub::Models::Compute::DataDisk.create_data_disk_response
    expected_response = ApiStub::Models::Compute::DataDisk.expected_create_data_disk_response
    assert_equal Fog::Compute::AzureRM::DataDisk.parse(mocked_response), expected_response
  end
end
