module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_public_ips(resource_group)
          Fog::Logger.debug "Getting list of PublicIPs from Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.list(resource_group)
            result = promise.value!
            Azure::ARM::Network::Models::PublicIPAddressListResult.serialize_object(result.body)['value']
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Public IPs from Resource Group '#{resource_group}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_public_ips(_resource_group)
          [
            {
              'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{_resource_group}/providers/Microsoft.Network/publicIPAddresses/test-PubIP",
              'name' => 'test-PubIP',
              'type' => 'Microsoft.Network/publicIPAddresses',
              'location' => 'westus',
              'properties' =>
                {
                  'publicIPAllocationMethod' => 'Static',
                  'ipAddress' => '13.93.203.153',
                  'idleTimeoutInMinutes' => 4,
                  'resourceGuid' => 'c78f0c95-d8b9-409b-897c-74260b686392',
                  'provisioningState' => 'Succeeded'
                },
              'etag' => "W/\"528b34bf-93ad-4dfc-a563-4005ff48e86d\""
            }
          ]

        end
      end
    end
  end
end
