class UserMailer < ActionMailer::Base
  default from: 'welcome@traileditor.org'

  def welcome_email(user, trailheads)
    @user = user    
    @trailheads = trailheads
    mail(from: "welcome@traileditor.org", to: @user.email, subject: 'Thanks for the Trailheads!')
  end

  def welcome_email_nogps(user, trailheads)
    @user = user    
    @trailheads = trailheads
    mail(from: "welcome@traileditor.org", to: @user.email, subject: 'Thanks for the Trailheads! Please fix...')
  end
end