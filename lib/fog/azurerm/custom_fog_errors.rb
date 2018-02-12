module Fog
    module AzureRM
        class CustomAzureOperationError < MsRestAzure::AzureOperationError
            
            def initialize(message, azure_exception)
                super("Exception in #{message}")
                @request = azure_exception.request.clone
                @response = azure_exception.response.clone
            end
        end

        class CustomAzureCoreHttpError < Azure::Core::Http::HTTPError

            def initialize (description, azure_exception)
                super("Exception in #{description}")
                @request = azure_exception.request.clone
                @response = azure_exception.response.clone
            end
        end
    end
end