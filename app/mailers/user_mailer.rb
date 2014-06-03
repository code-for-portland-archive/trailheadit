class UserMailer < ActionMailer::Base
  default from: 'welcome@traileditor.org'

  def welcome_email(user)
    @user = user    
    mail(from: "welcome@traileditor.prg", to: @user.email, subject: 'Welcome to My Trailheads')
  end
end