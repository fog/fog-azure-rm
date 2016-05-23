module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_virtual_machine(resource_group, name)
          begin
            promise = @compute_mgmt_client.virtual_machines.get(resource_group, name)
            response = promise.value!
            Azure::ARM::Compute::Models::VirtualMachine.serialize_object(response.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Virtual Machine #{name} from Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_virtual_machine(resource_group, name)
          {
              "location"=>"westus",
              "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/#{name}",
              "name"=>name,
              "type"=>"Microsoft.Compute/virtualMachines",
              "properties"=>
                  {
                      "hardwareProfile"=>
                          {
                              "vmSize"=>"Basic_A0"
                          },
                      "storageProfile"=>
                          {
                              "imageReference"=>
                                  {
                                      "publisher"=>"Canonical",
                                      "offer"=>"UbuntuServer",
                                      "sku"=>"14.04.2-LTS",
                                      "version"=>"latest"
                                  },
                              "osDisk"=>
                                  {
                                      "name"=>"#{name}_os_disk",
                                      "vhd"=>
                                          {
                                              "uri"=>"http://fogtestsafirst.blob.core.windows.net/vhds/testVM_os_disk.vhd"
                                          },
                                      "createOption"=>"FromImage",
                                      "osType"=>"Linux",
                                      "caching"=>"ReadWrite"
                                  },
                              "dataDisks"=>[]
                          },
                      "osProfile"=>
                          {
                              "computerName"=>name,
                              "adminUsername"=>"testfog",
                              "linuxConfiguration"=>
                                  {
                                      "disablePasswordAuthentication"=>false
                                  },
                              "secrets"=>[]
                          },
                      "networkProfile"=>
                          {
                              "networkInterfaces"=>
                                  [
                                      {
                                          "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/testNIC"
                                      }
                                  ]
                          },
                      "provisioningState"=>"Succeeded"
                  }
          }

        end
      end
    end
  end
end
