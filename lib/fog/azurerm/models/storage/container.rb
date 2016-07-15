module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for container.
      class Container < Fog::Model
        identity  :name
        attribute :metadata
      end
    end
  end
end
