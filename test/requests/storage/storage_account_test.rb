require File.expand_path '../../test_helper', __dir__
require 'minitest/autorun'
require 'azure_mgmt_compute'
require 'azure'
require 'concurrent'

class AvailabilitySetTest < Minitest::Test

  def setup
    @azure_credentials = Fog::Storage::AzureRM.new(credentials)
    client = @azure_credentials.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = client.storage_accounts
  end

  def test_create_storage_account
    mock_promise = Concurrent::Promise.execute do
    end
    storage_acc_obj = ApiStub::Requests::Storage::StorageAccount.create_storage_account
    properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
    properties.account_type = 'Standard_LRS' # This might change in the near future!

    params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
    params.properties = properties
    params.location = location
    mock_promise.stub :value!, storage_acc_obj do
      @storage_accounts.stub :create,mock_promise do
        assert_equal @azure_credentials.create_storage_account('gateway-RG','awain',params), storage_acc_obj
      end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :create,raise_exception do
      assert_raises(Exception) {@azure_credentials.create_storage_account('gateway-RG','awain',params) }
    end
  end

  def test_delete_storage_account
    @storage_accounts.stub :delete,nil do
      assert_equal @azure_credentials.delete_storage_account('gateway-RG','awain'), nil
    end
    assert_raises(ArgumentError){@azure_credentials.delete_storage_account('gateway-RG','awain','Hi') }

    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :delete,raise_exception do
      assert_raises(Exception) {@azure_credentials.delete_availability_set('gateway-RG','awain') }
    end
  end

  def test_list_storage_accounts_for_rg
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts_for_rg
    result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('','',''),Faraday::Response.new,Azure::ARM::Storage::Models::StorageAccountListResult.deserialize_object(response_body))
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list_by_resource_group,mock_promise do
        assert @azure_credentials.list_storage_account_for_rg('gateway-RG').size >= 1
        @azure_credentials.list_storage_account_for_rg('gateway-RG').each do |s|
          assert_instance_of Azure::ARM::Storage::Models::StorageAccount , s
          end
        end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :list_by_resource_group,raise_exception do
      assert_raises(Exception) {@azure_credentials.list_storage_account_for_rg('gateway-RG') }
    end
  end

  def test_list_storage_accounts
    mock_promise = Concurrent::Promise.execute do
    end
    response_body = ApiStub::Requests::Storage::StorageAccount.list_storage_accounts
    result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('','',''),Faraday::Response.new,Azure::ARM::Storage::Models::StorageAccountListResult.deserialize_object(response_body))
    mock_promise.stub :value!, result do
      @storage_accounts.stub :list,mock_promise do
        assert @azure_credentials.list_storage_accounts.size >= 1
        @azure_credentials.list_storage_accounts.each do |s|
          assert_instance_of Azure::ARM::Storage::Models::StorageAccount , s
        end
      end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :list,raise_exception do
      assert_raises(Exception) {@azure_credentials.list_storage_accounts }
    end
  end
  def test_check_storage_account_name_availability
    params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
    params.name = 'teststorageaccount'
    params.type = 'Microsoft.Storage/storageAccounts'
    mock_promise = Concurrent::Promise.execute do
    end
    true_case_response = ApiStub::Requests::Storage::StorageAccount.true_case_for_check_name_availability
    result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('','',''),Faraday::Response.new,Azure::ARM::Storage::Models::CheckNameAvailabilityResult.deserialize_object(true_case_response))
    mock_promise.stub :value!, result do
      @storage_accounts.stub :check_name_availability,mock_promise do
        assert_equal @azure_credentials.check_storage_account_name_availability(params),true
      end
    end
    false_case_response = ApiStub::Requests::Storage::StorageAccount.false_case_for_check_name_availability
    result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('','',''),Faraday::Response.new,Azure::ARM::Storage::Models::CheckNameAvailabilityResult.deserialize_object(false_case_response))
    mock_promise.stub :value!, result do
      @storage_accounts.stub :check_name_availability,mock_promise do
        assert_equal @azure_credentials.check_storage_account_name_availability(params),false
      end
    end
    raise_exception = -> { raise MsRestAzure::AzureOperationError.new }
    @storage_accounts.stub :check_name_availability,raise_exception do
      assert_raises(Exception) {@azure_credentials.check_storage_account_name_availability(params) }
    end
  end
  end
