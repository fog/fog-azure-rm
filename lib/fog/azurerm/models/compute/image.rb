module Fog
  module Compute
    class AzureRM
      class Image < Fog::Model
        attribute :id
        identity :name
        attribute :resource_group_name
        attribute :location
        attribute :provisioning_state
        attribute :source_server_id
        attribute :source_server_name
        attribute :managed_disk_id
        attribute :os_disk_size
        attribute :os_disk_state
        attribute :os_disk_type
        attribute :os_disk_caching
        attribute :os_disk_blob_uri
        attribute :tags
      end
    end
  end
end
