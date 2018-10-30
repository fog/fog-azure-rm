module Fog
  module Compute
    class AzureRM
      class Images < Fog::Collection
        attribute :resource_group
        model Fog::Compute::AzureRM::Image

        def create(attributes)
          image = new attributes
          image.save
        end

        def all(async = false)
          requires :resource_group
          images = service.list_images(resource_group, async).map do |image|
            Fog::Compute::AzureRM::Image.parse(image)
          end
          load(images)
        end

        def get(resource_group_name, image_name)
          response = service.get_image(resource_group_name, image_name)
          image = Fog::Compute::AzureRM::Image.new(service: service)
          image.merge_attributes(Fog::Compute::AzureRM::Image.parse(response))
        end
      end
    end
  end
end
