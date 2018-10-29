require File.expand_path '../../test_helper', __dir__
# Test class for VirtualMachineSize Model
class TestVirtualMachineSize < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @virtual_machine_size = virtual_machine_size(@service)
  end

  def test_model_attributes
    attributes = %i(
      name
      max_data_disk_count
      number_of_cores
      os_disk_size_in_mb
      resource_disk_size_in_mb
      memory_in_mb
    )
    attributes.each do |attribute|
      assert_respond_to @virtual_machine_size, attribute
    end
  end

  def test_parse_method
    virtual_machine_size_hash = Fog::Compute::AzureRM::VirtualMachineSize.parse(@response)
    @response.instance_variables.each do |attribute|
      assert_equal @response.instance_variable_get(attribute), virtual_machine_size_hash[attribute.to_s.delete('@')]
    end
  end
end
