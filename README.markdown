# carrierwave-raca

Store carrierwave files on Rackspace Cloud Files using the raca gem.
[raca](http://rubygems.org/gems/raca) is lightweight, rackspace-only alternative
to fog.

## Usage

Add this gem to your Gemfile:

    gem 'carrierwave-raca'

... and then modify config/environments/development.rb to add this at the bottom:

    CarrierWave.configure do |config|
      config.storage = :raca
      config.asset_host = "https://somehost.rackcdn.com"
      config.raca_username = "rackspace username"
      config.raca_api_key = "rackspace api_key"
      config.raca_container = "rackspace container name"
      config.raca_region = :ord # or :syd, :dfw, :iad, :hkg
    end

Depending on your intended setup, you might also need to add similar configuration
into other environments.
