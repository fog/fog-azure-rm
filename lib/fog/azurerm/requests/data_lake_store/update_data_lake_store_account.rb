module Fog
  module DataLakeStore
    class AzureRM
      # Real class for Data Lake Store Account Request
      class Real
        def update_data_lake_store_account(data_lake_store_update_parameters_account_params)
          msg = "Updating Data Lake Store Account #{data_lake_store_update_parameters_account_params[:name]} in Resource Group: #{data_lake_store_update_parameters_account_params[:resource_group]}."
          Fog::Logger.debug msg
          data_lake_store_update_parameters_account_object = get_data_lake_store_update_parameters_account_object(data_lake_store_update_parameters_account_params)
          begin
            account = @data_lake_store_account_client.account.update(data_lake_store_update_parameters_account_params[:resource_group], data_lake_store_update_parameters_account_params[:name], data_lake_store_update_parameters_account_object)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Data Lake Store Account #{data_lake_store_update_parameters_account_params[:name]} updated successfully."
          account
        end

        private

        def get_data_lake_store_update_parameters_account_object(data_lake_store_update_parameters_account_params)
          account = Azure::ARM::DataLakeStore::Models::DataLakeStoreAccountUpdateParameters.new
          account.firewall_state = data_lake_store_update_parameters_account_params[:firewall_state] unless data_lake_store_update_parameters_account_params[:firewall_state].nil?
          account.firewall_allow_azure_ips = data_lake_store_update_parameters_account_params[:firewall_allow_azure_ips] unless data_lake_store_update_parameters_account_params[:firewall_allow_azure_ips].nil?
          account.new_tier = data_lake_store_update_parameters_account_params[:new_tier] unless data_lake_store_update_parameters_account_params[:new_tier].nil?
          account
        end
      end

      # Mock class for Data Lake Store Account Request
      class Mock
        def update_data_lake_store_account(*)
          {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.DataLakeStore/accounts/name',
              'name' => name,
              'type' => 'Microsoft.DataLakeStore/accounts',
              'etag' => '00000002-0000-0000-76c2-f7ad90b5d101',
              'location' => 'East US 2',
              'tags' => {},
              'properties' =>
                  {
                      'encryption_state' => 'Enabled'
                  }
          }
        end
      end
    end
  end
end
