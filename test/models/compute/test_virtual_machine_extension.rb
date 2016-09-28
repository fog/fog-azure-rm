require File.expand_path '../../test_helper', __dir__

# Test class for VirtualMachineExtension Model
class TestVirtualMachineExtension < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @virtual_machine_extension = virtual_machine_extension(@service)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
  end

  def test_model_methods
    methods = [
      :save,
      :update,
      :destroy
    ]
    methods.each do |method|
      assert @virtual_machine_extension.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :resource_group,
      :location,
      :vm_name,
      :type,
      :publisher,
      :type_handler_version,
      :auto_upgrade_minor_version,
      :settings,
      :protected_settings
    ]
    attributes.each do |attribute|
      assert @virtual_machine_extension.respond_to? attribute, true
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Compute::VirtualMachineExtension.create_vm_extension_response(@compute_client)
    @service.stub :create_or_update_vm_extension, response do
      assert_instance_of Fog::Compute::AzureRM::VirtualMachineExtension, @virtual_machine_extension.save
    end
  end

  def test_update_method_response
    response = ApiStub::Models::Compute::VirtualMachineExtension.create_vm_extension_response(@compute_client)
    @service.stub :create_or_update_vm_extension, response do
      assert_instance_of Fog::Compute::AzureRM::VirtualMachineExtension, @virtual_machine_extension.update({})
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_vm_extension, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @virtual_machine_extension.destroy
    end
  end
end
