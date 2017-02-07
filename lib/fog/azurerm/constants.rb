AZURE_RESOURCE = 'https://management.azure.com'.freeze
DEFAULT_ADDRESS_PREFIXES = ['10.2.0.0/16'].freeze
SUBNET = 'Subnet'.freeze
PUBLIC_IP = 'Public-IP-Address'.freeze
NETWORK_SECURITY_GROUP = 'Network-Security-Group'.freeze
STANDARD_STORAGE = 'Standard'.freeze
PREMIUM_STORAGE = 'Premium'.freeze
ALLOWED_STANDARD_REPLICATION = %w(LRS ZRS GRS RAGRS).freeze
API_VERSION = '2016-06-01'.freeze
FAULT_DOMAIN_COUNT = 3
UPDATE_DOMAIN_COUNT = 5
WINDOWS = 'windows'.freeze
VPN = 'Vpn'.freeze
MICROSOFT_PEERING = 'MicrosoftPeering'.freeze
RESOURCE_GROUP_NAME = 4
RESOURCE_PROVIDER_NAMESPACE = 6
RESOURCE_TYPE = 7
RESOURCE_NAME = 8
ENDPOINT_PREFIX = 'Microsoft.Network/trafficManagerProfiles'.freeze
AZURE_ENDPOINTS = 'azureEndpoints'.freeze
EXTERNAL_ENDPOINTS = 'externalEndpoints'.freeze
NESTED_ENDPOINTS = 'nestedEndpoints'.freeze
GLOBAL = 'global'.freeze
UPLOAD_BLOB_WORKER_THREAD_COUNT = 8
VM_NAME_POSITION = 8

ENVIRONMENT_AZURE_CLOUD = 'AzureCloud'.freeze
ENVIRONMENT_AZURE_CHINA_CLOUD = 'AzureChinaCloud'.freeze
ENVIRONMENT_AZURE_US_GOVERNMENT = 'AzureUSGovernment'.freeze
ENVIRONMENT_AZURE_GERMAN_CLOUD = 'AzureGermanCloud'.freeze

PLATFORM_LINUX = 'linux'.freeze

# State of the copy operation
COPY_STATUS =
  {
    # The copy completed successfully.
    SUCCESS: 'success',
    # The copy is in progress
    PENDING: 'pending'
  }.freeze

# https://msdn.microsoft.com/en-us/library/azure/dd179451.aspx
# The maximum size for a block blob created via Put Blob is 64 MB. But for better performance, this size should be 32 MB.
# If your blob is larger than 32 MB, you must upload it as a set of blocks.
SINGLE_BLOB_PUT_THRESHOLD = 32 * 1024 * 1024

# Block blob: https://msdn.microsoft.com/en-us/library/azure/dd135726.aspx
# Page blob: https://msdn.microsoft.com/en-us/library/azure/ee691975.aspx
# Each block/page can be a different size, up to a maximum of 4 MB
MAXIMUM_CHUNK_SIZE = 4 * 1024 * 1024

# The hash value of 4MB empty content
HASH_OF_4MB_EMPTY_CONTENT = 'b5cfa9d6c8febd618f91ac2843d50a1c'.freeze
REST_CLIENT_API_VERSION = %w(2014-04-01-preview 2016-05-01).freeze
