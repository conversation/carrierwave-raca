require 'carrierwave'
require 'carrierwave/storage/raca'

class CarrierWave::Uploader::Base
  add_config :raca_username
  add_config :raca_api_key
  add_config :raca_region
  add_config :raca_container

  configure do |config|
    config.storage_engines[:raca] = 'CarrierWave::Storage::Raca'
  end
end
