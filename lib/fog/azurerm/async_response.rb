module Fog
  module AzureRM
    # class for Async Response
    class AsyncResponse
      def initialize(model, promise, flag = false)
        @fog_model = model
        @promise = promise
        @flag = flag
      end

      def value
        puts @promise.value.env.inspect
        puts @fog_model.inspect
        puts @flag.inspect
        response = @promise.value.env.body
        @fog_model.merge_attributes(@fog_model.class.parse(response))
        if @flag
          is_managed_custom_vm = !@fog_model.vhd_path.nil? && !@fog_model.managed_disk_storage_type.nil?
          delete_generalized_image(@fog_model.resource_group, @fog_model.name) if is_managed_custom_vm
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
