module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for storage account.
      class Container < Fog::Model
        identity  :name
        attribute :metadata

      end
    end
  end
end
