class UserMailer < ActionMailer::Base
  default from: 'welcome@traileditor.com'

  def welcome_email(user)
    @user = user    
    mail(from: "welcome@traileditor.com", to: @user.email, subject: 'Welcome to My Trailheads')
  end
end