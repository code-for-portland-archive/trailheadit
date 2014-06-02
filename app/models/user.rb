class User < ActiveRecord::Base
  has_many :trailheads
  after_create :welcome

  def welcome
    if Rails.env.production?
      UserMailer.welcome_email(@user).deliver
    end
  end

  def to_s
    email
  end
end
