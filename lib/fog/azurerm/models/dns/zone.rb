module Fog
  module DNS
    class AzureRM
      class Zone < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group

        def save
          requires :name
          requires :resource_group
          if service.check_for_zone(resource_group, name)
            Fog::Logger.debug "Zone #{zone_name} Exists, no need to create"
          else
            service.create_zone(resource_group, name)
          end

        end

        def destroy
          unless service.check_for_zone(resource_group, name)
            Fog::Logger.debug "Zone #{zone_name} does not exist, no need to delete"
          else
            service.delete_zone(name, resource_group)
          end
        end
      end
    end
  end
end
