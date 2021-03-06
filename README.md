= devise_sms
The user will receive an SMS with a token that can be entered on the site to activate the phone number.
Ask the user his phone and the token will be sended automagically.

gem 'devise_phone', git: 'https://github.com/carlosariasf/sms_devise.git'

=== Automatic installation
	
before installing devise_phone in your Rails app install Devise Gem

Run the following generator to add DevisePhone’s configuration option in the Devise configuration file (config/initializers/devise.rb) and the sms sender class in your lib folder:

    rails generate devise_phone:install

When you are done, you are ready to add DevisePhone to any of your Devise models using the following generator: 

    rails generate devise_phone MODEL

Replace MODEL by the class name you want to add DevisePhone, like User, Admin, etc. This will add the :phone flag to your model's Devise modules. The generator will also create a migration file (if your ORM support them). Continue reading this file to understand exactly what the generator produces and how to use it.

To specify the message body, in devise.en.yml add:

    en:
	  devise:
	    phone:
		  message_body: "Hi! This is Company Name. Your verification code is %{verification_code}."

== Configuring views

All the views are packaged inside the gem. If you'd like to customize the views, invoke the following generator and it will copy all the views to your application:

    rails generate devise_phone:views

You can also use the generator to generate scoped views: (This might not work yet)

    rails generate devise_phone:views users

Please refer to {Devise's README}[http://github.com/plataformatec/devise] for more information about views.

== Configuration Block

    DevisePhone.configure do |config|
        config.access_key = ''
        config.secret_key = ''
        config.personal_key = ''
    end

== Usage

Don't forget to add phone_number as one of the permitted parameters. This is an example of doing so:

	class ApplicationController < ActionController::Base
	  # Prevent CSRF attacks by raising an exception.
	  # For APIs, you may want to use :null_session instead.
	  protect_from_forgery with: :exception

	  before_filter :configure_permitted_parameters

	  protected

	  # my custom fields are :name, :heard_how
	  def configure_permitted_parameters
	    devise_parameter_sanitizer.for(:sign_up) do |u|
	      u.permit(:phone_number,
	        :email, :password, :password_confirmation)
	    end
	    devise_parameter_sanitizer.for(:account_update) do |u|
	      u.permit(:phone_number,
	        :email, :password, :password_confirmation, :current_password)
	    end
	  end
	end

The resend verification code button can be inserted to any page just by using:

    <%= render 'devise/phone/resend_code' %>

The activate phone field and button can be inserted to any page just by using:

    <%= render 'devise/phone/activate_phone' %>