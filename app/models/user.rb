class User < ActiveRecord::Base
  has_many :trailheads

  def to_s
    email
  end
end
