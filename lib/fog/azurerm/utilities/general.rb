# Pick Resource Group name from Azure Resource Id(String)
def get_resource_group_from_id(id)
  id.split('/')[4]
end

# Pick Virtual Network name from Subnet Resource Id(String)
def get_virtual_network_from_id(subnet_id)
  subnet_id.split('/')[8]
end

def get_record_type(type)
  type.split('/').last
end

def raise_azure_exception(exception, msg)
  message = "Exception #{msg} #{exception.body['error']['message'] unless exception.body['error']['message'].nil?} Type: #{exception.class} \n "
  Fog::Logger.debug exception.backtrace
  raise message
end

# Make sure if input_params(Hash) contains all keys present in required_params(Array)
def validate_params(required_params, input_params)
  missing_params = required_params.select { |param| param unless input_params.key?(param) }

  if missing_params.any?
    raise(ArgumentError, "Missing Parameters: #{missing_params.join(', ')} required for this operation")
  end
end
