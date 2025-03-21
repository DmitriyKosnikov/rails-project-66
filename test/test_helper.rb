# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

OmniAuth.config.test_mode = true
# WebMock.disable_net_connect!(allow_localhost: true)

module ActiveSupport
  class TestCase
    include ActionMailer::TestHelper

    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    Rails.application.routes.default_url_options[:host] = 'example.com'
  end
end

module ActionDispatch
  class IntegrationTest
    def sign_in(user)
      auth_hash = {
        provider: 'github',
        uid: '12345',
        info: {
          email: user.email,
          name: user.name,
          nickname: 'test_nickname',
          image: 'http://example.com/avatar.png'
        },
        credentials: {
          token: 'mock_github_token'
        }
      }

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(auth_hash)
      get callback_auth_path(:github)
    end

    def signed_in?
      session[:user_id].present? && current_user.present?
    end

    def current_user
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
end
