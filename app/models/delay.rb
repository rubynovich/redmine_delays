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

  scope :time_period, lambda {|q, field|
    today = Date.today
    if q.present? && field.present?
      period_start, period_end = case q
                                 when "yesterday"
                                   [ 1.day.ago.beginning_of_day, 1.day.ago.end_of_day ]
                                 when "today"
                                   [ today.beginning_of_day, today.end_of_day ]
                                 when "last_week"
                                   [ 1.week.ago.beginning_of_week, 1.week.ago.end_of_week ]
                                 when "this_week"
                                   [ today.beginning_of_week, today.end_of_week]
                                 when "last_month"
                                   [1.month.ago.beginning_of_month, 1.month.ago.end_of_month]
                                 when "this_month"
                                   [today.beginning_of_month, today.end_of_month]
                                 when "last_year"
                                   [1.year.ago.beginning_of_year, 1.year.ago.end_of_year ]
                                 when "this_year"
                                   [today.beginning_of_year, today.end_of_year ]
                                 end

      {:conditions => ["#{field} BETWEEN ? AND ?", period_start , period_end] }
     
    end
  }

  def to_s
    user ? user.name : ""
  end

end
