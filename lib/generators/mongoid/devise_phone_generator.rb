require 'generators/devise/orm_helpers'

module Mongoid
  module Generators
    class DevisePhoneGenerator < Rails::Generators::NamedBase
      namespace "devise_phone"

      def inject_devise_phone_content_fields
        path = File.join("app", "models", "#{file_path}.rb")
        inject_into_file(path, migration_data, :after => "# field :locked_at,       type: Time\n") if File.exists?(path)
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

    end
  end
end
