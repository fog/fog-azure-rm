module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_subnet(resource_group, virtual_network_name, subnet_name, addressPrefix)
          Fog::Logger.debug "Creating Subnet: #{subnet_name}..."
          subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          subnet_properties.address_prefix = addressPrefix unless addressPrefix.nil?

          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.name = subnet_name
          subnet.properties = subnet_properties
          begin
            promise = @network_client.subnets.create_or_update(resource_group, virtual_network_name, subnet_name, subnet)
            result = promise.value!
            Fog::Logger.debug "Subnet #{subnet_name} created successfully."
            Azure::ARM::Network::Models::Subnet.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception creating Subnet #{subnet_name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def create_subnet(_resource_group, _virtual_network_name, _subnet_name, _addressPrefix)
        end
      end
    end
  end
end
