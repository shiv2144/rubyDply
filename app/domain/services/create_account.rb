# Creates brand new customer account. This account is different
# because it was added manually by a trades company.
class CreateAccount
  include Wisper::Publisher

  def execute(performer, attributes)
    account = performer.company.accounts.new(attributes)
    if account.save
      # send_invite_email(performer, account)
      broadcast(:create_account_successful, performer, account)
    else
      broadcast(:create_account_failed, performer, account)
    end
  end

private

  # def send_invite_email(current_member, account)
  #   account.invite!(current_member)
  # end
end
