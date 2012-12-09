class Todo < ActiveRecord::Base
  attr_accessible :description, :done, :owner

  validates :description, presence: true, uniqueness: true

  def self.completed
    where(done: true)
  end

  def self.active
    where(done: [false, nil])
  end
end