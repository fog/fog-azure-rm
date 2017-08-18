module Fog
  module DataLakeStore
    class AzureRM
      # Real class for Data Lake Store Account Request
      class Real
        def create_data_lake_store_account(data_lake_store_account_params)
          msg = "Creating Data Lake Store Account #{data_lake_store_account_params[:name]} in Resource Group: #{data_lake_store_account_params[:resource_group]}."
          Fog::Logger.debug msg
          data_lake_store_account_object = get_data_lake_store_account_object(data_lake_store_account_params)
          begin
            account = @data_lake_store_account_client.account.create(data_lake_store_account_params[:resource_group], data_lake_store_account_params[:name], data_lake_store_account_object)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Data Lake Store Account #{data_lake_store_account_params[:name]} created successfully."
          account
        end

        private

        def get_data_lake_store_account_object(data_lake_store_account_params)
          account = Azure::ARM::DataLakeStore::Models::DataLakeStoreAccount.new
          account.name = data_lake_store_account_params[:name]
          account.location = data_lake_store_account_params[:location]
          account.type = 'Microsoft.DataLakeStore/accounts'
          account.firewall_state = data_lake_store_account_params[:firewall_state] unless data_lake_store_account_params[:firewall_state].nil?
          account.firewall_allow_azure_ips = data_lake_store_account_params[:firewall_allow_azure_ips] unless data_lake_store_account_params[:firewall_allow_azure_ips].nil?
          account.firewall_rules = define_firewall_rules_create(data_lake_store_account_params[:firewall_rules]) unless data_lake_store_account_params[:firewall_rules].nil?
          account.encryption_state = data_lake_store_account_params[:encryption_state] unless data_lake_store_account_params[:encryption_state].nil?
          account.encryption_config = get_config_create(data_lake_store_account_params) unless data_lake_store_account_params[:encryption_config].nil?
          account.new_tier = data_lake_store_account_params[:new_tier] unless data_lake_store_account_params[:new_tier].nil?
          account.current_tier = data_lake_store_account_params[:current_tier] unless data_lake_store_account_params[:current_tier].nil?
          account
        end

        def define_firewall_rules_create(firewall_rules_params)
          firewall_rules = []
          firewall_rules_params.each do |rule|
            firewall_rule = Azure::ARM::DataLakeStore::Models::FirewallRule.new
            firewall_rule.name = rule[:name]
            firewall_rule.start_ip_address = rule[:start_ip_address]
            firewall_rule.end_ip_address = rule[:end_ip_address]
            firewall_rules.push(firewall_rule)
          end
          firewall_rules
        end

        def get_config_create(data_lake_store_account_params)
          config = Azure::ARM::DataLakeStore::Models::EncryptionConfig.new
          config.type = data_lake_store_account_params[:encryption_config][:type] unless data_lake_store_account_params[:encryption_config][:type].nil?
          config.key_vault_meta_info = get_key_vault_meta_info_create(data_lake_store_account_params) unless data_lake_store_account_params[:encryption_config][:key_vault_meta_info].nil?
          config
        end

        def get_key_vault_meta_info_create(data_lake_store_account_params)
          meta = Azure::ARM::DataLakeStore::Models::KeyVaultMetaInfo.new
          meta.key_vault_resource_id = data_lake_store_account_params[:encryption_config][:key_vault_meta_info][:key_vault_resource_id] unless data_lake_store_account_params[:encryption_config][:key_vault_meta_info][:key_vault_resource_id].nil?
          meta.encryption_key_name = data_lake_store_account_params[:encryption_config][:key_vault_meta_info][:encryption_key_name] unless data_lake_store_account_params[:encryption_config][:key_vault_meta_info][:encryption_key_name].nil?
          meta.encryption_key_version = data_lake_store_account_params[:encryption_config][:key_vault_meta_info][:encryption_key_version] unless data_lake_store_account_params[:encryption_config][:key_vault_meta_info][:encryption_key_version].nil?
          meta
        end
      end

      # Mock class for Data Lake Store Account Request
      class Mock
        def create_data_lake_store_account(*)
          {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.DataLakeStore/accounts/name',
              'name' => name,
              'type' => 'Microsoft.DataLakeStore/accounts',
              'etag' => '00000002-0000-0000-76c2-f7ad90b5d101',
              'location' => 'East US 2',
              'tags' => {},
              'encryption_state' => 'Enabled'
          }
        end
      end
    end
  end
end
