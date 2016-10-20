require File.expand_path '../../test_helper', __dir__

class TestEnableBackupProtection < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = @service.recovery_vaults
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)

    @compute_service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @compute_service.instance_variable_get(:@compute_mgmt_client)
  end

  def test_enable_backup_protection_success
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_response(@compute_client)
    policy_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_protection_policy_response
    @service.stub :set_recovery_vault_context, true do
      @service.stub :get_backup_protection_policy, JSON.parse(policy_response)['value'] do
        @service.stub :get_virtual_machine_id, response.id do
          @service.stub :get_backup_job_for_vm, nil do
            @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
              RestClient.stub :put, true do
                assert_equal @service.enable_backup_protection('fog-test-vault', 'fog-test-rg', 'fog-test-vm', 'fog-test-vm-rg'), true
              end
            end
          end
        end
      end
    end
  end

  def test_enable_backup_protection_argument_error
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_response(@compute_client)
    policy_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_protection_policy_response
    @service.stub :set_recovery_vault_context, true do
      @service.stub :get_backup_protection_policy, JSON.parse(policy_response)['value'] do
        @service.stub :get_virtual_machine_id, response.id do
          @service.stub :get_backup_job_for_vm, nil do
            @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
              assert_raises ArgumentError do
                @service.enable_backup_protection('fog-test-vault', 'fog-test-rg')
              end
            end
          end
        end
      end
    end
  end

  def test_enable_backup_protection_exception
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_response(@compute_client)
    policy_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_protection_policy_response
    rest_client_response = -> { fail RestClient::Exception.new("'body': {'error': {'code': 'ResourceNotFound', 'message': 'mocked exception message'}}") }
    @service.stub :set_recovery_vault_context, true do
      @service.stub :get_backup_protection_policy, JSON.parse(policy_response)['value'] do
        @service.stub :get_virtual_machine_id, response.id do
          @service.stub :get_backup_job_for_vm, nil do
            @token_provider.stub :get_authentication_header, rest_client_response do
              assert_raises Exception do
                @service.enable_backup_protection('fog-test-vault', 'fog-test-rg', 'fog-test-vm', 'fog-test-vm-rg')
              end
            end
          end
        end
      end
    end
  end
end