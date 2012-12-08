class Todo < ActiveRecord::Base
  attr_accessible :description, :done, :owner

  def description
    return "empty" if super().blank?
    super()
  end

  def self.completed
    where(done: true)
  end

  def self.active
    where(done: [false, nil])
  end
end