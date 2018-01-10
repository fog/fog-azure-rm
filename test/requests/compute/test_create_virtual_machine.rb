require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Machine Request
class TestCreateVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = compute_client.virtual_machines
    @response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(compute_client)
    @custom_data_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_with_custom_data_response(compute_client)
    @linux_virtual_machine_hash = ApiStub::Requests::Compute::VirtualMachine.linux_virtual_machine_params
    @windows_virtual_machine_hash = ApiStub::Requests::Compute::VirtualMachine.windows_virtual_machine_params
    @error_response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
  end

  def test_create_linux_virtual_machine_success
    @virtual_machines.stub :create_or_update, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(@linux_virtual_machine_hash), @response
      end
    end

    # Async
    @virtual_machines.stub :create_or_update_async, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(@linux_virtual_machine_hash, true), @response
      end
    end
  end

  def test_create_windows_virtual_machine_success
    @virtual_machines.stub :create_or_update, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(@windows_virtual_machine_hash), @response
      end
    end

    # Async
    @virtual_machines.stub :create_or_update_async, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(@windows_virtual_machine_hash, true), @response
      end
    end
  end

  def test_create_linux_virtual_machine_from_custom_image_success
    linux_virtual_machine_with_custom_image_hash = ApiStub::Requests::Compute::VirtualMachine.linux_virtual_machine_with_custom_image_params
    @virtual_machines.stub :create_or_update, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(linux_virtual_machine_with_custom_image_hash), @response
      end
    end

    # Async
    @virtual_machines.stub :create_or_update_async, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(linux_virtual_machine_with_custom_image_hash, true), @response
      end
    end
  end

  def test_create_windows_virtual_machine_from_custom_image_success
    windows_virtual_machine_with_custom_image_hash = ApiStub::Requests::Compute::VirtualMachine.windows_virtual_machine_with_custom_image_params
    @virtual_machines.stub :create_or_update, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(windows_virtual_machine_with_custom_image_hash), @response
      end
    end

    # Async
    @virtual_machines.stub :create_or_update_async, @response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(windows_virtual_machine_with_custom_image_hash, true), @response
      end
    end
  end

  def test_create_linux_virtual_machine_with_custom_data_success
    linux_virtual_machine_with_custom_data_hash = ApiStub::Requests::Compute::VirtualMachine.linux_virtual_machine_with_custom_data_params
    @virtual_machines.stub :create_or_update, @custom_data_response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(linux_virtual_machine_with_custom_data_hash), @custom_data_response
      end
    end
  end

  def test_create_windows_virtual_machine_with_custom_data_success
    windows_virtual_machine_with_custom_data_hash = ApiStub::Requests::Compute::VirtualMachine.windows_virtual_machine_with_custom_data_params
    @virtual_machines.stub :create_or_update, @custom_data_response do
      @virtual_machines.stub :get, @error_response do
        assert_equal @service.create_virtual_machine(windows_virtual_machine_with_custom_data_hash), @custom_data_response
      end
    end
  end

  def test_create_virtual_machine_failure
    @virtual_machines.stub :create_or_update, @error_response do
      @virtual_machines.stub :get, @error_response do
        assert_raises RuntimeError do
          @service.create_virtual_machine(@linux_virtual_machine_hash)
        end
      end
    end

    # Async
    @virtual_machines.stub :create_or_update_async, @error_response do
      @virtual_machines.stub :get, @error_response do
        assert_raises RuntimeError do
          @service.create_virtual_machine(@linux_virtual_machine_hash, true)
        end
      end
    end
  end
end
