require 'csv'

class DailyAuditReportGenerator
  def perform params
    report_start_time = 1.day.ago.beginning_of_day
    report_end_time = report_start_time.end_of_day
    report = []
    PaperTrail::Version.where("created_at > ? AND created_at <= ? AND whodunnit_email IS NOT NULL", report_start_time, report_end_time).order("created_at ASC").each do |version|
      changes = format_object_change version
      if changes.present?
        report << [
          version.whodunnit_email,
          I18n.l(version.created_at),
          version.item_type,
          version.item_id,
          version.event,
          changes
        ]
      end
    end

    if report.present?
      report_csv_data = CSV.generate do |csv|
        csv << ["User", "Timestamp", "Item", "Item ID", "Event", "Changes"]
        report.each { |r| csv << r }
      end
      SystemMailer.daily_audit_report(report_start_time, report_csv_data.to_s, report.size).deliver
    end
  end

  def format_object_change version
    change_message = []
    if version.event == "create"
      change_message << YAML.load(version.object_changes).except(:id, :created_at, :updated_at).to_s
    elsif version.event == "destroy"
      change_message << YAML.load(version.object).except(:id, :created_at, :updated_at).to_s
    elsif version.event == "update"
      changes = YAML.load(version.object_changes)
      changes.each do |attribute, change|
        old_value = change.first
        new_value = change.last
        if [old_value, new_value].any?(&:present?) && !%w(created_at updated_at).include?(attribute)
          change_message << "#{attribute} changed from #{old_value} to #{new_value}"
        end
      end
    end
    change_message.join(",")
  end
end