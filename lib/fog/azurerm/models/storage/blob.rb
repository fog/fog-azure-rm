module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for storage account.
      class Blob < Fog::Model
        identity  :name
        attribute :container_name
        attribute :metadata
      end
    end
  end
end
