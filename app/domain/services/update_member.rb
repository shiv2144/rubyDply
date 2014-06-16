class UpdateMember
  include Wisper::Publisher

  def execute(performer, member, attributes)
    if member.update(attributes)
      broadcast(:update_member_successful, performer, member)
    else
      broadcast(:update_member_failed, performer, member)
    end
  end

end
