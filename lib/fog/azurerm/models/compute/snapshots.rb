module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check existence for snapshots of snapshots.
      class Snapshots < Fog::Collection
        model Fog::Compute::AzureRM::Snapshot
        attribute :resource_group
      end
    end
  end
end
