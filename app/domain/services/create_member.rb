class CreateMember
  include Wisper::Publisher

  def execute(performer, attributes)
    member = performer.company.members.new(attributes)
    if member.save
      send_invite_email(performer, member)
      broadcast(:create_member_successful, performer, member)
    else
      broadcast(:create_member_failed, performer, member)
    end
  end

  private

  def send_invite_email(current_member, member)
    member.invite!(current_member)
  end
end
