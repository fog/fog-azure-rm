require File.expand_path '../../test_helper', __dir__

# Test class for Disable Backup Protection request
class TestDisableBackupProtection < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = @service.recovery_vaults
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)

    @compute_service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @compute_service.instance_variable_get(:@compute_mgmt_client)
  end

  def test_disable_backup_protection_success
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_response(@compute_client)
    @service.stub :set_recovery_vault_context, true do
      @service.stub :get_virtual_machine_id, response.id do
        @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
          RestClient.stub :put, true do
            assert_equal @service.disable_backup_protection('fog-test-vault', 'fog-test-rg', 'fog-test-vm', 'fog-test-vm-rg'), true
          end
        end
      end
    end
  end

  def test_disable_backup_protection_argument_error
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_response(@compute_client)
    @service.stub :set_recovery_vault_context, true do
      @service.stub :get_virtual_machine_id, response.id do
        @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
          assert_raises ArgumentError do
            @service.disable_backup_protection('fog-test-vault', 'fog-test-rg')
          end
        end
      end
    end
  end

  def test_disable_backup_protection_exception
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_response(@compute_client)
    rest_client_response = -> { fail RestClient::Exception.new("'body': {'error': {'code': 'ResourceNotFound', 'message': 'mocked exception message'}}") }
    @service.stub :set_recovery_vault_context, true do
      @service.stub :get_virtual_machine_id, response.id do
        @token_provider.stub :get_authentication_header, rest_client_response do
          assert_raises Exception do
            @service.disable_backup_protection('fog-test-vault', 'fog-test-rg', 'fog-test-vm', 'fog-test-vm-rg')
          end
        end
      end
    end
  end
end
