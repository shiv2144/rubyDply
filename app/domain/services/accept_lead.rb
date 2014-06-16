class AcceptLead
  include Wisper::Publisher

  def execute(performer, lead)
    if lead.accepted_at.nil?
      lead.accepted_at = Time.now.utc.to_s(:db)
      if lead.save!
        account = create_account(lead)
        create_job(lead, account)
        broadcast(:accept_lead_successful, performer, lead)
      else
        broadcast(:accept_lead_failed, performer, lead)
      end
    else
      broadcast(:accept_lead_failed, performer, lead)
    end
  end

private

  # Creates new job based on lead data.The view
  # should take care of hiding user details until
  # the lead appointment has been approved by the user.
  def create_job(lead, account)
    Job.create({
        company_id: lead.company_id,
        trade_id: lead.trade_id,
        name: lead.job_name,
        description: lead.job_description,
        lead_id: lead.id,
        address_id: lead.address_id,
        account_id: account.id
      })
  end

  # Creates new account based on lead data.
  # This account doesn't have any personal detail
  # since thats maintained by the champ user.
  def create_account(lead)
    Account.create({
        company_id: lead.company_id,
        user_id: lead.user_id
      })
  end

end
