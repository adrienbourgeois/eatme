OmniAuth.config.logger = Rails.logger

if File.exist?("#{Rails.root.to_s}/config/config.yml")

  API_CREDENTIALS = YAML.load_file("#{Rails.root.to_s}/config/config.yml")

  Instagram.configure do |config|
    config.client_id = API_CREDENTIALS['instagram_client_id']
    config.client_secret = API_CREDENTIALS['instagram_client_secret']
  end

  Client_google = GooglePlaces::Client.new(API_CREDENTIALS['google_api_key'])

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, API_CREDENTIALS['facebook_app_id'], API_CREDENTIALS['facebook_app_secret']
  end

else

  Instagram.configure do |config|
    config.client_id = ENV['instagram_client_id']
    config.client_secret = ENV['instagram_client_secret']
  end

  Client_google = GooglePlaces::Client.new(ENV['google_api_key'])

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :facebook, ENV['facebook_app_id'], ENV['facebook_app_secret']
  end

end

