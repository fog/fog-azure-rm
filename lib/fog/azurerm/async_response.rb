module Fog
  module AzureRM
    # class for Async Response
    class AsyncResponse
      def initialize(model, promise, delete_extra_resource = false, post_method_execute = nil)
        @fog_model = model
        @promise = promise
        @delete_extra_resource = delete_extra_resource
        @post_method_execute = post_method_execute
      end

      def value
        response = @promise.value.body
        @fog_model.merge_attributes(@fog_model.class.parse(response))
        @fog_model.delete_extra_resources if @delete_extra_resource
        # This code block will execute the method mentioned in post_method_execute after getting the response
        unless @post_method_execute.nil?
          @fog_model.public_send(@post_method_execute) if @fog_model.respond_to? @post_method_execute
        end
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
