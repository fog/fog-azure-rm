module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def create_or_update_managed_disk(managed_disk_params)
          msg = "Creating/Updating Managed Disk: #{managed_disk_params[:name]}"
          Fog::Logger.debug msg
          disk = get_managed_disk_object(managed_disk_params)
          begin
            managed_disk = @compute_mgmt_client.disks.create_or_update(managed_disk_params[:resource_group_name], managed_disk_params[:name], disk)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Managed Disk #{managed_disk_params[:name]} created/updated successfully."
          managed_disk
        end

        private

        def get_managed_disk_object(managed_disk_params)
          managed_disk = Azure::Compute::Profiles::Latest::Mgmt::Models::Disk.new
          managed_disk.name = managed_disk_params[:name]
          managed_disk.type = DISK_PREFIX
          managed_disk.location = managed_disk_params[:location]
          managed_disk.sku = get_sku_object(managed_disk_params[:sku])
          managed_disk.os_type = managed_disk_params[:os_type]
          managed_disk.disk_size_gb = managed_disk_params[:disk_size_gb]
          managed_disk.tags = managed_disk_params[:tags] if managed_disk.tags.nil?

          creation_data = managed_disk_params[:creation_data]
          managed_disk.creation_data = get_creation_data_object(creation_data) unless creation_data.nil?

          encryption_settings = managed_disk_params[:encryption_settings]
          managed_disk.encryption_settings = get_encryption_settings_object(encryption_settings) unless encryption_settings.nil?

          managed_disk
        end

        def get_sku_object(sku_params)
          sku = Azure::Compute::Profiles::Latest::Mgmt::Models::Sku.new
          sku.name = sku_params[:name]
          sku.tier = sku_params[:tier]
          sku
        end

        def get_creation_data_object(data)
          creation_data = Azure::Compute::Profiles::Latest::Mgmt::Models::CreationData.new
          creation_data.create_option = data[:create_option]
          creation_data.storage_account_id = data[:storage_account_id]
          creation_data.source_uri = data[:source_uri]
          creation_data.source_resource_id = data[:source_resource_id]

          image_reference = data[:image_reference]
          unless image_reference.nil?
            image_disk_reference = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageDiskReference.new
            image_disk_reference.id = image_reference[:id]
            image_disk_reference.lun = image_reference[:lun]

            creation_data.image_reference = image_disk_reference
          end
          creation_data
        end

        def get_encryption_settings_object(settings)
          encryption_settings = Azure::Compute::Profiles::Latest::Mgmt::Models::EncryptionSettings.new
          disk_encryption_key = Azure::Compute::Profiles::Latest::Mgmt::Models::KeyVaultAndSecretReference.new
          disk_encryption_key.secret_url = settings[:secret_url]
          disk_encryption_key.source_vault.id = settings[:disk_source_vault_id]
          encryption_settings.disk_encryption_key = disk_encryption_key

          encryption_settings.enabled = settings[:enabled]

          key_encryption_key = Azure::Compute::Profiles::Latest::Mgmt::Models::KeyVaultAndKeyReference.new
          key_encryption_key.key_url = settings[:key_uri]
          key_encryption_key.source_vault = settings[:key_source_vault_id]
          encryption_settings.key_encryption_key = key_encryption_key

          encryption_settings
        end
      end

      # Mock class for Compute Request
      class Mock
        def create_or_update_managed_disk(*)
          disk = {
            'accountType' => 'Standard_LRS',
            'properties' => {
              'osType' => 'Windows',
              'creationData' => {
                'createOption' => 'Empty'
              },
              'diskSizeGB' => 10,
              'encryptionSettings' => {
                'enabled' => true,
                'diskEncryptionKey' => {
                  'sourceVault' => {
                    'id' => '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault'
                  },
                  'secretUrl' => 'https://myvmvault.vault-int.azure-int.net/secrets/{secret}'
                },
                'keyEncryptionKey' => {
                  'sourceVault' => {
                    'id' => '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.KeyVault/vaults/myVMVault'
                  },
                  'keyUrl' => 'https://myvmvault.vault-int.azure-int.net/keys/{key}'
                }
              },
              'timeCreated' => '2016-12-28T02:46:21.3322041+00:00',
              'provisioningState' => 'Succeeded',
              'diskState' => 'Unattached'
            },
            'type' => 'Microsoft.Compute/disks',
            'location' => 'westus',
            'tags' => {
              'department' => 'Development',
              'project' => 'ManagedDisks'
            },
            'id' => '/subscriptions/{subscriptionId}/resourceGroups/myResourceGroup/providers/Microsoft.Compute/disks/myManagedDisk1',
            'name' => 'myManagedDisk1'
          }
          disk_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::Disk.mapper
          @compute_mgmt_client.deserialize(disk_mapper, disk, 'result.body')
        end
      end
    end
  end
end
