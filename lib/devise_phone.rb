require "devise"

$: << File.expand_path("..", __FILE__)

require "devise_phone/configuration"
require "devise_phone/routes"
require "devise_phone/schema"
require 'devise_phone/controllers/url_helpers'
require 'devise_phone/controllers/helpers'
require 'devise_phone/rails'

module Devise
end

module DevisePhone
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

Devise.add_module :phone, :model => "models/phone", :controller => :phone_verifications, :route => :phone_verification
