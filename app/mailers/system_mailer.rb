class SystemMailer < ActionMailer::Base
  def daily_audit_report(date, report_csv_data)
    mail(subject: "Audit report for #{l(date, format: :only_date)}",
         reply_to: Jobrunner::Application.config.system_email,
         from: Jobrunner::Application.config.system_email,
         to: "projects@akshay.cc"
    ) do |format|
        format.text do
          attachments["Audit report - #{l(date, format: :only_date)}.csv"] = { content: report_csv_data, mime_type: "text/csv" }
          render text: "Audit report for #{l(date, format: :only_date)}"
        end
    end
  end
end