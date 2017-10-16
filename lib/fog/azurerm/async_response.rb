module Fog
  module AzureRM
    # class for Async Response
    class AsyncResponse
      def initialize(model, promise, delete_extra_resource = false)
        @fog_model = model
        @promise = promise
        @delete_extra_resource = delete_extra_resource
      end

      def value
        response = @promise.value.body
        @fog_model.merge_attributes(@fog_model.class.parse(response))
        @fog_model.delete_extra_resources if @delete_extra_resource
        @fog_model
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
