module Fog
  module Compute
    class AzureRM
      class Images < Fog::Collection
        attribute :resource_group
        model Fog::Compute::AzureRM::Image

        def get(resource_group_name, image_name)
          response = service.get_image(resource_group_name, image_name)
          image = Fog::Compute::AzureRM::Image.new(service: service)
          image.merge_attributes(Fog::Compute::AzureRM::Image.parse(response))
        end
      end
    end
  end
end
