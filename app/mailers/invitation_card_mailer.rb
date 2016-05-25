class InvitationCardMailer < ApplicationMailer

  def invitation_card(email)
    @email = email
    @home_url = root_url
    attachments.inline['wedding_invitation_card_sg.jpg'] = File.read("#{Rails.root}/app/assets/images/wedding_invitation_card_sg.jpg")
    mail(to: email,
         subject: "Juliette and Coen's wedding invitation card")
  end

end
