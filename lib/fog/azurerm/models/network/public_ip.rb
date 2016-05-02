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

          service.create_public_ip(resource_group, name, location, type)
        end

        def destroy
          service.delete_public_ip(resource_group, name)
        end
      end
    end
  end
end
