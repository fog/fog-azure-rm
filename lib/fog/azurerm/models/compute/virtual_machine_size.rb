module Fog
  module Compute
    class AzureRM
      class VirtualMachineSize < Fog::Model
        identity  :name
        attribute :max_data_disk_count
        attribute :number_of_cores
        attribute :os_disk_size_in_mb
        attribute :resource_disk_size_in_mb
        attribute :memory_in_mb

        def self.parse(virtual_machine_size)
          get_hash_from_object(virtual_machine_size)
        end
      end
    end
  end
end
