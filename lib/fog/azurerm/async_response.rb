module Fog
  module AzureRM
    # class for Async Response
    class AsyncResponse
      def initialize(model, promise)
        @fog_model = model
        @promise = promise
      end

      def value
        response = @promise.value.body
        @fog_model.merge_attributes(@fog_model.class.parse(response))
      end

      def state
        @promise.state
      end

      def reason
        @promise.reason
      end

      def pending?
        @promise.pending?
      end

      def fulfilled?
        @promise.fulfilled?
      end

      def rejected?
        @promise.rejected?
      end
    end
  end
end
