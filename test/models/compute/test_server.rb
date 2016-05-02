require File.expand_path '../../test_helper', __dir__

# Test class for Server Model
class TestServer < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @server = server(@service)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy,
      :generalize,
      :power_off,
      :start,
      :restart,
      :deallocate,
      :redeploy,
      :list_available_sizes
    ]
    methods.each do |method|
      assert @server.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :location,
      :resource_group,
      :vm_size,
      :storage_account_name,
      :os_disk_name,
      :vhd_uri,
      :publisher,
      :offer,
      :sku,
      :version,
      :username,
      :password,
      :disable_password_authentication,
      :ssh_key_path,
      :ssh_key_data,
      :network_interface_card_id,
      :availability_set_id
    ]
    attributes.each do |attribute|
      assert @server.respond_to? attribute, true
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Compute::Server.create_virtual_machine_response
    @service.stub :create_virtual_machine, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.save
    end
  end

  def test_destroy_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :delete_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.destroy
    end
  end

  def test_generalize_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :generalize_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.generalize
    end
  end

  def test_power_off_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :power_off_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.power_off
    end
  end

  def test_start_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :start_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.start
    end
  end

  def test_restart_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :restart_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.restart
    end
  end

  def test_deallocate_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :deallocate_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.deallocate
    end
  end

  def test_redeploy_method_response
    response = ApiStub::Models::Compute::Server.delete_virtual_machine_response
    @service.stub :redeploy_virtual_machine, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @server.redeploy
    end
  end

  def test_list_available_sizes_method_response
    response = ApiStub::Models::Compute::Server.list_available_sizes_for_virtual_machine_response
    @service.stub :list_available_sizes_for_virtual_machine, response do
      assert_instance_of Array, @server.list_available_sizes
    end
  end
end
