class SystemMailer < ActionMailer::Base
  SYSTEM_RECIPIENTS = %w(chip@pmgdirect.net vicky@pmgdirect.net cwright@pmgdirect.net sean@engageyourcause.com lori@mmidirect.com projects@akshay.cc)

  def daily_audit_report(date, no_of_entries)
    @date = date
    @no_of_entries = no_of_entries

    mail(subject: "Audit report for #{l(date, format: :only_date)}",
         reply_to: Jobrunner::Application.config.system_email,
         from: Jobrunner::Application.config.system_email,
         to: SYSTEM_RECIPIENTS
    )
  end
end
