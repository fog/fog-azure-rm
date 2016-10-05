require File.expand_path '../../test_helper', __dir__

# Test class for Data Disk Model
class TestDataDisk < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @data_disk = Fog::Storage::AzureRM::DataDisk.new
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
      assert_respond_to @data_disk, attribute
    end
  end
end
