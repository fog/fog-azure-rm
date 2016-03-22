require "fog/core"

module Fog
  module AzureRM
    extend Fog::Provider
    service(:resources, "Resources")
    service(:dns, "DNS")
  end
end