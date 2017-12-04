module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check existence for snapshots of snapshots.
      class Snapshots < Fog::Collection
        model Fog::Compute::AzureRM::Snapshot
        attribute :resource_group

        def all
          snapshots = if resource_group.nil?
                        service.list_snapshots_in_subscription
                      else
                        requires :resource_group
                        service.list_snapshots_by_rg(resource_group)
                      end
          snapshots = snapshots.map { |snapshot| Fog::Compute::AzureRM::Snapshot.parse snapshot }

          load(snapshots)
        end
      end
    end
  end
end
