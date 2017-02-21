module Fog
  module Compute
    class AzureRM
      # OperationStatusResponse model for Compute Service
      class OperationStatusResponse < Fog::Model
        attribute :name
        attribute :status
        attribute :start_time
        attribute :end_time
        attribute :error

        def self.parse(operation_status_response)
          get_hash_from_object(operation_status_response)
        end
      end
    end
  end
end