module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def get_managed_disk(resource_group_name, disk_name)
          msg = "Getting Managed Disk: #{disk_name}"
          Fog::Logger.debug msg
          begin
            managed_disk = @compute_mgmt_client.disks.get(resource_group_name, disk_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Managed Disk #{disk_name} returned successfully."
          managed_disk
        end
      end

      # Mock class for Compute Request
      class Mock
        def get_managed_disk(*)
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
