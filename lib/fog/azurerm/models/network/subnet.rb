module Fog
  module Network
    class AzureRM
      class Subnet < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :addressPrefix
        attribute :ipConfigurations

        def save
        end

        def destroy
        end
      end
    end
  end
end
