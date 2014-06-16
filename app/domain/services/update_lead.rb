class UpdateLead
  include Wisper::Publisher

  def execute(performer, lead, attributes)
    if lead.update(attributes)
      broadcast(:update_lead_successful, performer, lead)
    else
      broadcast(:update_lead_failed, performer, lead)
    end
  end

end
