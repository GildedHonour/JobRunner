class DailyAuditReportGenerator
  def perform
    report_start_time = 1.day.ago.beginning_of_day
    no_of_changes = Version.where("created_at > ? AND created_at <= ?", report_start_time, report_start_time.end_of_day).size
    SystemMailer.daily_audit_report(report_start_time, no_of_changes).deliver unless no_of_changes.zero?
  end
end
