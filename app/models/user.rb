class User < ActiveRecord::Base
  has_many :trailheads

  def label
    email
  end
  
  def to_s
    email.split('@')[0]
  end
end
