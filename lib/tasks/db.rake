namespace :db do
  desc "Rebuilds the DB from scratch"
  task :redo => :environment do
    if Rails.env.development?
      Rake::Task["db:drop"].execute
      Rake::Task["db:create"].execute
      system "echo '' > db/schema.rb"
      Rake::Task["db:migrate"].execute
      Rake::Task["db:seed"].execute
      Rake::Task["db:test:clone"].execute
    else
      puts "This can only be run in development environment"
    end
  end
end