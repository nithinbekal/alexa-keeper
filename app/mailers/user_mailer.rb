class UserMailer < ApplicationMailer
  default from: 'rankhub@gmail.com'
 
  def welcome_email(user)
    @user = user
    @url  = 'rankhub.co'
    mail(to: @user, subject: 'Welcome to RankHub')
  end

  def invite_email(invite,str,hash)
    @invite = invite
    @str = str
    @hash = hash
    @url  = 'rankhub.co'+@hash
    mail(to: @invite.email, subject: 'Welcome to RankHub')
  end
  
  def contact_email(conc)
    @cont = conc
    mail(to: "rankhub@gmail.com", subject: 'RankHub')
  end
  
  def feedback_email(fb)
    @feedback=fb
    mail(to: "rankhub@gmail.com", subject: 'RankHub')
  end

  def weekly_mail(user,data)
     @user = user.email
     @data = data
     mail(to: @user, subject: "Weekly report")
 end

end
