module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check existence for managed disk.
      class ManagedDisks < Fog::Collection
        model Fog::Compute::AzureRM::ManagedDisk
        attribute :resource_group
        def all
          if !resource_group.nil?
            requires :resource_group
            disks = service.list_managed_disks_by_rg(resource_group)
          else
            disks = service.list_managed_disks_in_subscription
          end
          managed_disks = disks.map { |disk| Fog::Compute::AzureRM::ManagedDisk.parse(disk) }

          load(managed_disks)
        end

        def get(resource_group_name, disk_name = nil)
          # Monkey patch for fog-core-2 compatibility
          if disk_name.nil?
            disks = service.list_managed_disks_in_subscription
            disk = disks.each do |disk|
              break disk if disk.name == resource_group_name
            end
          else
            disk = service.get_managed_disk(resource_group_name, disk_name)
          end
          managed_disk_fog = Fog::Compute::AzureRM::ManagedDisk.new(service: service)
          managed_disk_fog.merge_attributes(Fog::Compute::AzureRM::ManagedDisk.parse(disk))
        end

        def check_managed_disk_exists(resource_group, disk_name)
          service.check_managed_disk_exists(resource_group, disk_name)
        end

        def grant_access(resource_group_name, disk_name, access_type, duration_in_sec)
          service.grant_access_to_managed_disk(resource_group_name, disk_name, access_type, duration_in_sec)
        end

        def revoke_access(resource_group_name, disk_name)
          response = service.revoke_access_to_managed_disk(resource_group_name, disk_name)
          operation_status_response = Fog::Compute::AzureRM::OperationStatusResponse.new(service: service)
          operation_status_response.merge_attributes(Fog::Compute::AzureRM::OperationStatusResponse.parse(response))
        end
      end
    end
  end
end
