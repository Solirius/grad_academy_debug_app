I18n.available_locales = Dir[Rails.root.join('config/locales/*.yml')].map do |file|
  File.basename(file, '.yml').to_sym
end
I18n.default_locale = :en
