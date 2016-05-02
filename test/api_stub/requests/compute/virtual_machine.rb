module ApiStub
  module Requests
    module Compute
      # Mock class for Virtual Machine Requests
      class VirtualMachine
        def self.create_virtual_machine_response
          body = '{
            "id":"/subscriptions/{subscription-id}/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/fog-test-server",
            "name":"fog-test-server",
            "type":"Microsoft.Compute/virtualMachines",
            "location":"westus",
            "tags": {
              "department":"finance"
            },
            "properties": {
              "availabilitySet": {
                "id":"/subscriptions/{subscription-id}/resourceGroups/myresourcegroup1/providers/Microsoft.Compute/availabilitySets/myav1"
              },
              "hardwareProfile": {
                "vmSize":"Standard_A0"
              },
              "storageProfile": {
                "imageReference": {
                  "publisher":"MicrosoftWindowsServerEssentials",
                  "offer":"WindowsServerEssentials",
                  "sku":"WindowsServerEssentials",
                  "version":"latest"
                },
                "osDisk": {
                  "name":"myosdisk1",
                  "vhd": {
                    "uri":"http://mystorage1.blob.core.windows.net/vhds/myosdisk1.vhd"
                  },
                  "caching":"ReadWrite",
                  "createOption":"FromImage"
                },
                "dataDisks": [ {
                   "name":"mydatadisk1",
                   "diskSizeGB":"1",
                   "lun": 0,
                   "vhd": {
                     "uri" : "http://mystorage1.blob.core.windows.net/vhds/mydatadisk1.vhd"
                   },
                   "createOption":"Empty"
                 } ]
              },
              "osProfile": {
                "computerName":"fog-test-server",
                "adminUsername":"fog",
                "adminPassword":"fog",
                "customData":"",
                "windowsConfiguration": {
                  "provisionVMAgent":true,
                  "winRM": {
                    "listeners": [ {
                      "protocol": "https",
                      "certificateUrl": "url-to-certificate"
                    } ]
                  },
                  "enableAutomaticUpdates":true
                },
                "secrets":[ {
                   "sourceVault": {
                     "id": "/subscriptions/{subscription-id}/resourceGroups/myresourcegroup1/providers/Microsoft.KeyVault/vaults/myvault1"
                   },
                   "vaultCertificates": [ {
                     "certificateUrl": "https://myvault1.vault.azure.net/secrets/{secretName}/{secretVersion}",
                     "certificateStore": "{certificateStoreName}"
                   } ]
                 } ]
              },
              "networkProfile": {
                "networkInterfaces": [ {
                  "id":"/subscriptions/{subscription-id}/resourceGroups/myresourceGroup1/providers /Microsoft.Network/networkInterfaces/mynic1"
                } ]
              }
            }
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Compute::Models::VirtualMachine.deserialize_object(JSON.load(body))
          result
        end

        def self.list_virtual_machines_response
          body = '{
            "value": [
              {
                "id":"/subscriptions/{subscription-id}/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/fog-test-server",
                "name":"fog-test-server",
                "type":"Microsoft.Compute/virtualMachines",
                "location":"westus",
                "tags": {
                  "department":"finance"
                },
                "properties": {
                  "availabilitySet": {
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myresourcegroup1/providers/Microsoft.Compute/availabilitySets/myav1"
                  },
                  "hardwareProfile": {
                    "vmSize":"Standard_A0"
                  },
                  "storageProfile": {
                    "imageReference": {
                      "publisher":"MicrosoftWindowsServerEssentials",
                      "offer":"WindowsServerEssentials",
                      "sku":"WindowsServerEssentials",
                      "version":"latest"
                    },
                    "osDisk": {
                      "name":"myosdisk1",
                      "vhd": {
                        "uri":"http://mystorage1.blob.core.windows.net/vhds/myosdisk1.vhd"
                      },
                      "caching":"ReadWrite",
                      "createOption":"FromImage"
                    },
                    "dataDisks": [ {
                       "name":"mydatadisk1",
                       "diskSizeGB":"1",
                       "lun": 0,
                       "vhd": {
                         "uri" : "http://mystorage1.blob.core.windows.net/vhds/mydatadisk1.vhd"
                       },
                       "createOption":"Empty"
                     } ]
                  },
                  "osProfile": {
                    "computerName":"fog-test-server",
                    "adminUsername":"fog",
                    "adminPassword":"fog",
                    "customData":"",
                    "windowsConfiguration": {
                      "provisionVMAgent":true,
                      "winRM": {
                        "listeners": [ {
                          "protocol": "https",
                          "certificateUrl": "url-to-certificate"
                        } ]
                      },
                      "enableAutomaticUpdates":true
                    },
                    "secrets":[ {
                       "sourceVault": {
                         "id": "/subscriptions/{subscription-id}/resourceGroups/myresourcegroup1/providers/Microsoft.KeyVault/vaults/myvault1"
                       },
                       "vaultCertificates": [ {
                         "certificateUrl": "https://myvault1.vault.azure.net/secrets/{secretName}/{secretVersion}",
                         "certificateStore": "{certificateStoreName}"
                       } ]
                     } ]
                  },
                  "networkProfile": {
                    "networkInterfaces": [ {
                      "id":"/subscriptions/{subscription-id}/resourceGroups/myresourceGroup1/providers /Microsoft.Network/networkInterfaces/mynic1"
                    } ]
                  }
                }
              }
            ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Compute::Models::VirtualMachineListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.list_available_sizes_for_virtual_machine_response
          body = '{
            "value": [
              {
                "name": "Standard_A0",
                "numberOfCores": 1,
                "osDiskSizeInMB": 130048,
                "resourceDiskSizeInMB": 20480,
                "memoryInMB": 768,
                "maxDataDiskCount": 1
              }
            ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Compute::Models::VirtualMachineSizeListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.deallocate_virtual_machine_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
