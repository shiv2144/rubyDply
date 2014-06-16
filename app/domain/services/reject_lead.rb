class AcceptLead
  include Wisper::Publisher

  def execute(performer, lead)
    lead.rejected_at = Time.now.utc.to_s(:db)
    if lead.save!
      broadcast(:reject_lead_successful, performer, lead)
    else
      broadcast(:reject_lead_failed, performer, lead)
    end
  end

end
