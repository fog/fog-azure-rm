require File.expand_path '../../test_helper', __dir__

# Test class for Server Model
class TestServer < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @server = server(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Compute::Server.create_virtual_machine_response
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
    @service.stub :create_virtual_machine, response do
      methods.each do |method|
        assert @server.respond_to? method, true
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Compute::Server.create_virtual_machine_response
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
    @service.stub :create_virtual_machine, response do
      attributes.each do |attribute|
        assert @server.respond_to? attribute, true
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Compute::Server.create_virtual_machine_response
    @service.stub :create_virtual_machine, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.save
    end
  end
end
