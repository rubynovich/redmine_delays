class Delay < ActiveRecord::Base
  unloadable

  belongs_to :user
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'

  validates_presence_of :user_id, :author_id, :arrival_time, :delay_on

  if Rails::VERSION::MAJOR >= 3
    scope :like_username, lambda {|q|
      if q.present?
        {:conditions =>
          ["LOWER(users.firstname) LIKE :p OR users.firstname LIKE :p OR LOWER(users.lastname) LIKE :p OR users.lastname LIKE :p",
          {:p => "%#{q.to_s.downcase}%"}],
         :include => :user}
      end
    }

    scope :eql_field, lambda{ |q, field|
      where(field => q) if q.present? && field.present?
    }

    scope :time_period, lambda {|q, field|
      today = Date.today
      if q.present? && field.present?
        {:conditions =>
          (case q
            when "yesterday"
              ["#{field} BETWEEN ? AND ?",
                2.days.ago,
                1.day.ago]
            when "today"
              ["#{field} BETWEEN ? AND ?",
                1.day.ago,
                1.day.from_now]
            when "tomorrow"
              ["#{field} BETWEEN ? AND ?",
                1.day.from_now,
                2.days.from_now]
            when "prev_week"
              ["#{field} BETWEEN ? AND ?",
                2.week.ago + today.wday.days,
                1.week.ago + today.wday.days]
            when "this_week"
              ["#{field} BETWEEN ? AND ?",
                1.week.ago + today.wday.days,
                1.week.from_now - today.wday.days]
            when "next_week"
              ["#{field} BETWEEN ? AND ?",
                1.week.from_now - today.wday.days,
                2.week.from_now - today.wday.days]
            when "prev_month"
              ["#{field} BETWEEN ? AND ?",
                2.month.ago + today.day.days,
                1.month.ago + today.day.days]
            when "this_month"
              ["#{field} BETWEEN ? AND ?",
                1.month.ago + today.day.days,
                1.month.from_now - today.day.days]
            when "next_month"
              ["#{field} BETWEEN ? AND ?",
                1.month.from_now - today.day.days,
                2.month.from_now - today.day.days]
            when "prev_year"
              ["#{field} BETWEEN ? AND ?",
                2.year.ago + today.yday.days,
                1.year.ago + today.yday.days]
            when "this_year"
              ["#{field} BETWEEN ? AND ?",
                1.year.from_now - today.yday.days,
                1.year.from_now - today.yday.days]
            when "next_year"
              ["#{field} BETWEEN ? AND ?",
                1.year.from_now - today.yday.days,
                2.year.from_now - today.yday.days]
            else
              {}
          end)
        }
      end
    }
  else
    named_scope :like_username, lambda {|q|
      if q.present?
        {:conditions =>
          ["LOWER(users.firstname) LIKE :p OR users.firstname LIKE :p OR LOWER(users.lastname) LIKE :p OR users.lastname LIKE :p",
          {:p => "%#{q.to_s.downcase}%"}],
         :joins => :user}
      end
    }

    named_scope :eql_field, lambda{ |q, field|
      {:conditions => {field => q}} if q.present? && field.present?
    }

    named_scope :time_period, lambda {|q, field|
      today = Date.today
      if q.present? && field.present?
        {:conditions =>
          (case q
            when "yesterday"
              ["#{field} BETWEEN ? AND ?",
                2.days.ago,
                1.day.ago]
            when "today"
              ["#{field} BETWEEN ? AND ?",
                1.day.ago,
                1.day.from_now]
            when "tomorrow"
              ["#{field} BETWEEN ? AND ?",
                1.day.from_now,
                2.days.from_now]
            when "prev_week"
              ["#{field} BETWEEN ? AND ?",
                2.week.ago + today.wday.days,
                1.week.ago + today.wday.days]
            when "this_week"
              ["#{field} BETWEEN ? AND ?",
                1.week.ago + today.wday.days,
                1.week.from_now - today.wday.days]
            when "next_week"
              ["#{field} BETWEEN ? AND ?",
                1.week.from_now - today.wday.days,
                2.week.from_now - today.wday.days]
            when "prev_month"
              ["#{field} BETWEEN ? AND ?",
                2.month.ago + today.day.days,
                1.month.ago + today.day.days]
            when "this_month"
              ["#{field} BETWEEN ? AND ?",
                1.month.ago + today.day.days,
                1.month.from_now - today.day.days]
            when "next_month"
              ["#{field} BETWEEN ? AND ?",
                1.month.from_now - today.day.days,
                2.month.from_now - today.day.days]
            when "prev_year"
              ["#{field} BETWEEN ? AND ?",
                2.year.ago + today.yday.days,
                1.year.ago + today.yday.days]
            when "this_year"
              ["#{field} BETWEEN ? AND ?",
                1.year.from_now - today.yday.days,
                1.year.from_now - today.yday.days]
            when "next_year"
              ["#{field} BETWEEN ? AND ?",
                1.year.from_now - today.yday.days,
                2.year.from_now - today.yday.days]
            else
              {}
          end)
        }
      end
    }
  end

  def to_s
    if user
      user.name
    else
      ""
    end
  end
end
