Rails.application.config.middleware.use OmniAuth::Builder do
  provide :steam, ENV['STEAM_WEB_API_KEY']
end
