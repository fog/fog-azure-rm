module Fog
  module DNS
    class AzureRM
      # This class is giving an implementation of 'CNAME' RecordSet type
      class CnameRecord < Fog::Model
        attribute :cname

        def self.parse(cnamerecord)
          hash = {}
          hash['cname'] = cnamerecord.cname
          hash
        end
      end
    end
  end
end
