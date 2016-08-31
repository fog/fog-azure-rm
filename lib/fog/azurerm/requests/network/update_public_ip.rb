module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def update_public_ip(resource_group, name, location, public_ip_allocation_method, idle_timeout_in_minutes, domain_name_label)
          msg = "Updating PublicIP #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg

          public_ip = get_public_ip_object(name, location, public_ip_allocation_method, idle_timeout_in_minutes, domain_name_label)
          begin
            public_ip_obj = @network_client.public_ipaddresses.create_or_update(resource_group, name, public_ip)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "PublicIP #{name} Updated Successfully!"
          public_ip_obj
        end

        private

        def get_public_ip_object(name, location, public_ip_allocation_method, idle_timeout_in_minutes, domain_name_label)
          public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = name
          public_ip.location = location
          public_ip.public_ipallocation_method = public_ip_allocation_method
          public_ip.idle_timeout_in_minutes = idle_timeout_in_minutes
          unless domain_name_label.nil?
            public_ip.dns_settings = Azure::ARM::Network::Models::PublicIPAddressDnsSettings.new
            public_ip.dns_settings.domain_name_label = domain_name_label
          end

          public_ip
        end
      end

      # Mock class for Network Request
      class Mock
        def update_public_ip(*)
          public_ip = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/publicIPAddresses/fog-test-ip',
            'name' => 'testPubIp432',
            'type' => 'Microsoft.Network/publicIPAddresses',
            'location' => 'westus',
            'properties' =>
              {
                'publicIPAllocationMethod' => 'Dynamic',
                'ipAddress' => '13.91.253.67',
                'idleTimeoutInMinutes' => '10',
                'resourceGuid' => '767b1955-94de-433c-8e4a-ea0ad25e8d0c',
                'provisioningState' => 'Succeeded'
              }
          }
          public_ip_mapper = Azure::ARM::Network::Models::PublicIPAddress.mapper
          @network_client.deserialize(public_ip_mapper, public_ip, 'result.body')
        end
      end
    end
  end
end
