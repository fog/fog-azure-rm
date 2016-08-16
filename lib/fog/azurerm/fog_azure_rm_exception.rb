module Fog
  module AzureRM
    # Custom exception class
    class OperationError < MsRestAzure::AzureOperationError
      def initialize(exception)
        super(exception.body['error']['message'])
        self.request = exception.request
        self.response = exception.response
        set_backtrace(exception.backtrace)
      end
    end
  end
end
