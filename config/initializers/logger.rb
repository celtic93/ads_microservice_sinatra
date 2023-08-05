Application.configure do |app|
  logger = Ougai::Logger.new(app.root.concat('/', Settings.logger.path), level: Settings.logger.level)

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] ||= Thread.current[:request_id]&.to_i(36)&.to_s&.chars&.last(15)&.join
  end

  app.set :logger, logger
end

Sequel::Model.db.loggers.push(Application.logger)
