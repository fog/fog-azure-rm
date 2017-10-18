module Fog
  module DNS
    class AzureRM
      # This class is giving an implementation of 'CNAME' RecordSet type
      class CnameRecord < Fog::Model
        attribute :cname

        def self.parse(cnamerecord)
          hash = get_hash_from_object(cnamerecord)
          hash
        end
      end
    end
  end
end
