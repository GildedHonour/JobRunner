namespace :staging do
  task :deploy do
    sh "git push staging develop:master"
  end

  task :console do
    Bundler.with_clean_env do
      sh "heroku run rails console -a jobrunner-staging"
    end
  end

  task :logs do
    Bundler.with_clean_env do
      sh "heroku logs --tail -a jobrunner-staging"
    end
  end

  task :config do
    Bundler.with_clean_env do
      sh "heroku config -a jobrunner-staging"
    end
  end

  task :open do
    sh "open https://jobrunner-staging.herokuapp.com"
  end

  task :deploy_setup do
    sh "git remote add staging git@heroku.com:jobrunner-staging.git"
  end
end

namespace :production do
  task :deploy do
    sh "git push production master"
  end

  task :console do
    Bundler.with_clean_env do
      sh "heroku run rails console -a jobrunner"
    end
  end

  task :logs do
    Bundler.with_clean_env do
      sh "heroku logs --tail -a jobrunner"
    end
  end

  task :config do
    Bundler.with_clean_env do
      sh "heroku config -a jobrunner"
    end
  end

  task :open do
    sh "open https://jobrunner-production.herokuapp.com"
  end

  task :deploy_setup do
    sh "git remote add production git@heroku.com:jobrunner-production.git"
  end
end

