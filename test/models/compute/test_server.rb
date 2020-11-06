require File.expand_path '../../test_helper', __dir__

# Test class for Server Model
class TestServer < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @server = server(@service)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
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
      :list_available_sizes,
      :attach_data_disk,
      :detach_data_disk,
      :attach_managed_disk,
      :detach_managed_disk
    ]
    methods.each do |method|
      assert_respond_to @server, method
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
      :os_disk_id,
      :os_disk_vhd_uri,
      :os_disk_caching,
      :publisher,
      :offer,
      :sku,
      :version,
      :username,
      :password,
      :data_disks,
      :disable_password_authentication,
      :ssh_key_path,
      :ssh_key_data,
      :platform,
      :provision_vm_agent,
      :enable_automatic_updates,
      :network_interface_card_ids,
      :availability_set_id,
      :managed_disk_storage_type,
      :os_disk_size,
      :tags,
      :platform_update_domain,
      :platform_fault_domain
    ]
    attributes.each do |attribute|
      assert_respond_to @server, attribute
    end
  end

  def test_save_method_response_for_linux_vm
    response = ApiStub::Models::Compute::Server.create_linux_virtual_machine_response(@compute_client)
    @service.stub :create_virtual_machine, response do
      @service.stub :get_virtual_machine, response do
        assert_instance_of Fog::Compute::AzureRM::Server, @server.save
      end
    end

    # Async
    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :create_virtual_machine, async_response do
      assert_instance_of Concurrent::Promise, @server.save(true)
    end
  end

  def test_save_method_response_for_windows_vm
    response = ApiStub::Models::Compute::Server.create_windows_virtual_machine_response(@compute_client)
    @service.stub :create_virtual_machine, response do
      @service.stub :get_virtual_machine, response do
        assert_instance_of Fog::Compute::AzureRM::Server, @server.save
        refute @server.save.disable_password_authentication
      end
    end
  end

  def test_destroy_method_response
    @service.stub :delete_virtual_machine, true do
      assert @server.destroy
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :delete_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.destroy(true)
    end
  end

  def test_generalize_method_response
    @service.stub :generalize_virtual_machine, true do
      assert @server.generalize
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :generalize_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.generalize(true)
    end
  end

  def test_power_off_method_response
    @service.stub :power_off_virtual_machine, true do
      assert @server.power_off
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :power_off_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.power_off(true)
    end
  end

  def test_start_method_response
    @service.stub :start_virtual_machine, true do
      assert @server.start
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :start_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.start(true)
    end
  end

  def test_restart_method_response
    @service.stub :restart_virtual_machine, true do
      assert @server.restart
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :restart_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.restart(true)
    end
  end

  def test_deallocate_method_response
    @service.stub :deallocate_virtual_machine, true do
      assert @server.deallocate
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :deallocate_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.deallocate(true)
    end
  end

  def test_redeploy_method_response
    @service.stub :redeploy_virtual_machine, true do
      assert @server.redeploy
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :redeploy_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.redeploy(true)
    end
  end

  def test_vm_status_method_response
    @service.stub :check_vm_status, 'running' do
      assert_equal @server.vm_status, 'running'
    end
  end

  def test_list_available_sizes_method_response
    response = ApiStub::Models::Compute::Server.list_available_sizes_for_virtual_machine_response(@compute_client)
    @service.stub :list_available_sizes_for_virtual_machine, response do
      assert_instance_of Array, @server.list_available_sizes(false)
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :list_available_sizes_for_virtual_machine, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.list_available_sizes(true)
    end
  end

  def test_attach_data_disk_response
    response = ApiStub::Models::Compute::Server.attach_data_disk_response(@compute_client)
    @service.stub :attach_data_disk_to_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.attach_data_disk('disk1', '10', 'mystorage1')
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :attach_data_disk_to_vm, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.attach_data_disk('disk', '10', 'mystorage1', true)
    end
  end

  def test_detach_data_disk_response
    response = ApiStub::Models::Compute::Server.create_linux_virtual_machine_response(@compute_client)
    @service.stub :detach_data_disk_from_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.detach_data_disk('disk1')
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :detach_data_disk_from_vm, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.detach_data_disk('disk1', true)
    end
  end

  def test_attach_managed_disk_response
    response = ApiStub::Models::Compute::Server.attach_managed_disk_response(@compute_client)
    @service.stub :attach_data_disk_to_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.attach_managed_disk('disk_name', 'resoure_group')
    end
    @service.stub :attach_data_disk_to_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.attach_managed_disk('disk_name', 'resoure_group', false, 'ReadOnly')
    end
    @service.stub :attach_data_disk_to_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.attach_managed_disk('disk_name', 'resoure_group', false, 'ReadWrite')
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :attach_data_disk_to_vm, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.attach_managed_disk('managed_disk_name', 'resoure_group', true)
    end
  end

  def test_detach_managed_disk_response
    response = ApiStub::Models::Compute::Server.create_linux_virtual_machine_response(@compute_client)
    @service.stub :detach_data_disk_from_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.detach_managed_disk('managed_disk_name')
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :detach_data_disk_from_vm, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.detach_managed_disk('managed_disk_name', true)
    end
  end

  def test_detach_managed_disks_response
    response = ApiStub::Models::Compute::Server.create_linux_virtual_machine_response(@compute_client)
    @service.stub :detach_data_disk_from_vm, response do
      assert_instance_of Fog::Compute::AzureRM::Server, @server.detach_managed_disks(%w(managed_disk_name1 managed_disk_name2))
    end

    async_response = Concurrent::Promise.execute { 10 }
    @service.stub :detach_data_disk_from_vm, async_response do
      assert_instance_of Fog::AzureRM::AsyncResponse, @server.detach_managed_disks(%w(managed_disk_name1 managed_disk_name2), true)
    end
  end
end
