class UpdateProfile
  include Wisper::Publisher

  def execute(performer, profile, attributes)
    if profile.update(attributes)
      broadcast(:update_profile_successful, performer, profile)
    else
      broadcast(:update_profile_failed, performer, profile)
    end
  end

end
