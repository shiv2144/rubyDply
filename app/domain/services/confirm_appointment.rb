class ConfirmAppointment
  include Wisper::Publisher

  def execute(performer, event)
    event.confirmed_at = Time.now.utc.to_s(:db)
    if event.save!
      mark_lead_approved(event)
      broadcast(:accept_lead_successful, performer, event)
    else
      broadcast(:accept_lead_failed, performer, event)
    end
  end


private

  # Updates leads approved_at timestamp if exists
  def mark_lead_approved(event)
    if event.job.lead && event.job.lead.approved_at.nil?
      event.job.lead.update(approved_at: Time.now.utc)
    end
  end
end
