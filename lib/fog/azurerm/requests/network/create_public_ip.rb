module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_public_ip(resource_group, name, location, public_ip_allocation_method)
          Fog::Logger.debug "Creating PublicIP #{name} in Resource Group #{resource_group}."
          properties = Azure::ARM::Network::Models::PublicIPAddressPropertiesFormat.new
          properties.public_ipallocation_method = public_ip_allocation_method
          
          public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = name
          public_ip.location = location
          public_ip.properties = properties
          begin
            promise = @network_client.public_ipaddresses.create_or_update(resource_group, name, public_ip)
            result = promise.value!
            Fog::Logger.debug "PublicIP #{name} Created Successfully!"
            Azure::ARM::Network::Models::PublicIPAddress.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Public IP #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def create_public_ip(_resource_group, _name, _location, _public_ip_allocation_method)
        end
      end
    end
  end
end
