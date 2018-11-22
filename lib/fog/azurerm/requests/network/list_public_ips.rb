module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_public_ips(resource_group)
          Fog::Logger.debug "Getting list of PublicIPs from Resource Group #{resource_group}."
          begin
            public_ips = @network_client.public_ipaddresses.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Getting list of PublicIPs from Resource Group #{resource_group}")
          end
          Fog::Logger.debug 'Public IP listed successfully'
          public_ips.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_public_ips(resource_group)
          public_ip = {
            'value' =>
            [
              {
                'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/publicIPAddresses/test-PubIP",
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
                  }
              }
            ]
          }
          public_ip_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddressListResult.mapper
          @network_client.deserialize(public_ip_mapper, public_ip, 'result.body').value
        end
      end
    end
  end
end
