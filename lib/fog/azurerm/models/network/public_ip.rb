module Fog
  module Network
    class AzureRM
      # PublicIP model class for Network Service
      class PublicIp < Fog::Model
        identity :name
        attribute :type
        attribute :location
        attribute :resource_group

        def save
          requires :name
          requires :type
          requires :location
          requires :resource_group

          properties = Azure::ARM::Network::Models::PublicIPAddressPropertiesFormat.new
          properties.public_ipallocation_method = type

          public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = name
          public_ip.location = location
          public_ip.properties = properties

          service.create_public_ip(resource_group, name, public_ip)
        end

        def destroy
          service.delete_public_ip(resource_group, name)
        end
      end
    end
  end
end
