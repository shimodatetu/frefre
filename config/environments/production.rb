Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true
  config.action_cable.allowed_request_origins = [ /http:\/\/.*/ ]
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  config.assets.js_compressor = :uglifier
  config.assets.compile = true

  config.active_storage.service = :amazon
  config.force_ssl = true

  config.log_level = :debug

  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.delivery_method       = :smtp
  config.action_mailer.default_url_options   = { host: 'frefreforum.com' }
  # Do not dump schema after migrations.
  mail = ENV['MAIL_ADDRESS']
  pass = ENV['MAIL_PASSWORD']
  config.action_mailer.smtp_settings = {
    enable_starttls_auto: true,
    address: 'smtp.gmail.com',
    port: '587',
    domain: 'gmail.com',
    authentication: 'plain',
    user_name: mail,
    password: pass
  }
end
