require 'yaml'
require 'logger'
require 'sequel'

namespace :db do

  desc "Run database migrations"
  task :migrate do
    require 'sequel/extensions/migration'
    Sequel::Migrator.apply(database, migrate_dir)
  end

  desc "Rollback the database"
  task :rollback do
    require 'sequel/extensions/migration'
    version = (row = database[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(database, migrate_dir, version - 1)
  end

  desc "Nuke the database (drop all tables)"
  task :nuke do
    require "highline/import"
    next unless agree("Are you sure you want to drop all tables?:[yes|no]")
    database.tables.each do |table|
      puts "dropping table: #{table}"
      database.run("DROP TABLE #{table}")
    end
  end

  desc "Reset the database"
  task :reset => [:nuke, :migrate]

  private
  def root
    File.expand_path("..", File.dirname(__FILE__))
  end

  def migrate_dir
    File.join root, "db/migrate"
  end

  def database
    env = ENV["DB_ENV"] || "development"
    options = YAML.load_file(File.join(root, 'config/database.yml'))[env]
    options[:logger] = logger(Rake.verbose == true ? Logger::DEBUG : Logger::INFO)
    db = Sequel.connect(options)
    db.sql_log_level = :debug
    db
  end

  def logger(level = Logger::INFO)
    logger = Logger.new($stdout)
    logger.level = level
    logger.formatter = lambda { |severity, datetime, progname, message| "#{message}\n" }
    logger
  end

end
