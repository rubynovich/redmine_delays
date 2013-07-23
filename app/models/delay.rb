class Delay < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates_presence_of :user_id, :author_id, :arrival_time, :delay_on

  scope :like_username, lambda {|q|
    if q.present?
      {:conditions =>
        ["LOWER(users.firstname) LIKE :p OR users.firstname LIKE :p OR LOWER(users.lastname) LIKE :p OR users.lastname LIKE :p",
         {:p => "%#{q.to_s.downcase}%"}],
        :joins => :user}
    end
  }

  scope :eql_field, lambda{ |q, field|
    where(field => q) if q.present? && field.present?
  }

  def to_s
    user ? user.name : ""
  end

end
