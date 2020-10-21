require 'generators/devise/orm_helpers'

module Mongoid
  module Generators
    class DevisePhoneGenerator < Rails::Generators::NamedBase
      namespace "devise_phone"

      def inject_devise_phone_content_fields
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, migration_data, :after => "# field :locked_at,       type: Time\n") if File.exists?(path)
        create_file("app/models/sms.rb", sms_data)
      end

      def migration_data
        <<RUBY
 # DevisePhone fields
  field :phone_number, type: String
  field :phone_number_verified, type: Boolean
  field :phone_verification_code_sent_at, type: Time
  field :phone_verified_at, type: Time
  field :phone_verification_code, type: String
RUBY
      end

      def sms_data
        <<RUBY
# Sms sender model
class Sms
  include ActiveModel::Model
  attr_accessor :phone_number, :message
  #after_create :send_sms
  def initialize
    @phone_number = ''
    @message = ''
  end

  def persisted?
    True
  end

  def send!
    send_sms
    true
  end
 private
  def send_sms
    ActionCable.server.broadcast("global_stream", {phone_number: @phone_number, message: @message})
  end
end
RUBY

      end

  end
end
