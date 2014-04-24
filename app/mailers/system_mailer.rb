class SystemMailer < ActionMailer::Base
  SYSTEM_RECIPIENTS = %w(chip@pmgdirect.net vicky@pmgdirect.net cwright@pmgdirect.net sean@engageyourcause.com lori@mmidirect.com projects@akshay.cc)

  def daily_audit_report(date, report_csv_data, no_of_entries)
    mail(subject: "Audit report for #{l(date, format: :only_date)}",
         reply_to: Jobrunner::Application.config.system_email,
         from: Jobrunner::Application.config.system_email,
         to: SYSTEM_RECIPIENTS
    ) do |format|
        format.text do
          attachments["Audit report - #{l(date, format: :only_date)}.csv"] = { content: report_csv_data, mime_type: "text/csv" }
          render text: "Audit report for #{l(date, format: :only_date)}.\nNo. of changes: #{no_of_entries}\n"
        end
    end
  end
end