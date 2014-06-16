class MemberMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`

  layout "notifications_mailer"

  before_filter :add_inline_attachments!


private

  def add_inline_attachments!
    # attachments.inline['champ-logo.png'] = File.read("#{Rails.root}/app/assets/images/champ-logo.png")
    attachments.inline['champ-logo.png'] = File.read(Rails.root.join('app/assets/images/champ-logo.png').to_s)
  end

end
