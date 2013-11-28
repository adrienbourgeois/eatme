if File.exist?("#{Rails.root.to_s}/config/config.yml")
  API_CREDENTIALS = YAML.load_file("#{Rails.root.to_s}/config/config.yml")
  Instagram.configure do |config|
    config.client_id = API_CREDENTIALS['instagram_client_id']
    config.client_secret = API_CREDENTIALS['instagram_client_secret']
  end
else
  Instagram.configure do |config|
    config.client_id = ENV['instagram_client_id']
    config.client_secret = ENV['instagram_client_secret']
  end
end

