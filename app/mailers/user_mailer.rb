class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user    
    mail(to: @user.email, subject: 'Welcome to My Trailheads')
  end
end