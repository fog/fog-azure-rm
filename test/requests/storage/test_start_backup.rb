require File.expand_path '../../test_helper', __dir__

class TestStartBackup < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_start_backup_success
    backup_item_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_item_response
    @service.stub :get_backup_job_for_vm, nil do
      @service.stub :get_backup_item, JSON.parse(backup_item_response)['value'] do
        @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
          RestClient.stub :post, true do
            assert_equal @service.start_backup('fog-test-rg', 'fog-test-vault', 'fog-test-vm', 'fog-test-vm-rg'), true
          end
        end
      end
    end
  end

  def test_start_backup_job_running
    backup_job_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_job_for_vm_response
    @service.stub :get_backup_job_for_vm, JSON.parse(backup_job_response) do
      assert_equal @service.start_backup('fog-test-rg', 'fog-test-vault', 'fog-test-vm', 'fog-test-vm-rg'), false
    end
  end

  def test_start_backup_argument_error
    backup_item_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_item_response
    @service.stub :get_backup_job_for_vm, nil do
      @service.stub :get_backup_item, JSON.parse(backup_item_response)['value'] do
        @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
          assert_raises ArgumentError do
            @service.start_backup('fog-test-rg', 'fog-test-vault')
          end
        end
      end
    end
  end

  def test_start_backup_exception
    backup_item_response = ApiStub::Requests::Storage::RecoveryVault.get_backup_item_response
    rest_client_response = -> { fail Exception.new('mocked exception') }
    @service.stub :get_backup_job_for_vm, nil do
      @service.stub :get_backup_item, JSON.parse(backup_item_response)['value'] do
        @token_provider.stub :get_authentication_header, rest_client_response do
          assert_raises Exception do
            assert_equal @service.start_backup('fog-test-rg', 'fog-test-vault', 'fog-test-vm', 'fog-test-vm-rg'), true
          end
        end
      end
    end
  end
end
