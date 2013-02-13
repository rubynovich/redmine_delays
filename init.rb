require 'redmine'

Redmine::Plugin.register :redmine_delays do
  name "Delays"
  author "Roman Shipiev"
  description 'Plugin fixes delays of employees'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_delays'
  author_url 'http://roman.shipiev.me/'

  menu :application_menu, :delays,
    {:controller => :delays, :action => :index},
    :caption => :label_delay_plural,
    :after => :vacation_statuses,
    :if => Proc.new{ User.current.is_vacation_manager?}
end
