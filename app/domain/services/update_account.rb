class UpdateAccount
  include Wisper::Publisher

  def execute(performer, account, attributes)
    if account.update(attributes)
      broadcast(:update_account_successful, performer, account)
    else
      broadcast(:update_account_failed, performer, account)
    end
  end

end
