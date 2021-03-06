require "devise_phone/hooks"

module Devise
  module Models
    module Phone
      extend ActiveSupport::Concern

      included do
        before_create :set_unverified_phone_attributes, :if => :phone_verification_needed?
        # after_create  :private_generate_verification_code_and_send_sms, :if => :phone_verification_needed?
        # before_save  :remember_old_phone_number
        after_save  :private_generate_verification_code_and_send_sms, :if => :regenerate_phone_verification_needed?
      end

      def generate_verification_code_and_send_sms
        if(phone_verification_needed?)
          private_generate_verification_code_and_send_sms
        end
        save!
        end

      def verify_phone_number_with_code_entered(code_entered)
        if phone_verification_needed? && (code_entered == phone_verification_code)
          mark_phone_as_verified!
          true
        else
          false
        end
      end

      private

      def private_generate_verification_code_and_send_sms
        set_unverified_phone_attributes
        send_sms_verification_code if phone_number.present?
      end


      def mark_phone_as_verified!
        update!(phone_number_verified: true,
               phone_verification_code: nil,
               phone_verification_code_sent_at: nil,
               phone_verified_at: DateTime.now)
      end

      # check if phone verification is needed and set errors here
      def phone_verification_needed?
        if phone_number.blank?
          errors.add(:phone_verification_code, :empty_phone_number_field)
          false
        elsif phone_number_verified
          errors.add(:phone_verification_code, :phone_verification_not_needed)
          false
        else
          true
        end
      end

      def regenerate_phone_verification_needed?
        if phone_number.present?
          if phone_number_changed?
            true
          else
            false
          end
          # self.errors.add(:phone_verification_code, :empty_phone_number_field)
          # false
        else
          false
        end
      end

      # set attributes to user indicating the phone number is unverified
      def set_unverified_phone_attributes
        if phone_verification_code.nil?
          self.phone_verification_code = generate_phone_verification_code
        end
        self.phone_number_verified = false
        self.phone_verification_code_sent_at = DateTime.now
        self.phone_verified_at = nil
        # removes all white spaces, hyphens, and parenthesis
        phone_number.gsub!(/[\s\-\(\)]+/, '') if phone_number
      end

      # return 6 digits random code a-z,0-9
      def generate_phone_verification_code
        verification_code = SecureRandom.hex(3)
        verification_code
      end

      # sends a message to number indicated in the secrets.yml
      def send_sms_verification_code
        number_to_send_to = phone_number
        verification_code = phone_verification_code
        sms_message_body = I18n.t("devise.phone.message_body", :verification_code => verification_code)

        sms = Sms.new
        sms.phone_number = number_to_send_to
        sms.message = sms_message_body
        return false unless sms.send!

        true
      end

    end
  end
end
