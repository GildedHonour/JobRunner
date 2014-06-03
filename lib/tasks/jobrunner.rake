namespace :jobrunner do

  desc "Sends out the daily audit report"
  task send_daily_audit_report: :environment do
    DailyAuditReportGenerator.new.perform
  end
end
