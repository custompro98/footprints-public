require 'database_cleaner'

if Rails.env == "production"
  puts "Don't run seeds in production!"
elsif Rails.env == 'staging'
  DatabaseCleaner.clean_with(:deletion)

  require "#{Rails.root}/db/staging_seeds.rb"
  StagingSeeds.run
else
  require "#{Rails.root}/db/default_seeds.rb"
end
