require 'redmine'

Redmine::Plugin.register :redmine_delays do
  name "Регистрация опозданий"
  author "Roman Shipiev"
  description 'Регистрирует опоздания сотрудников на работу. Требует предустановки модуля "Отсуствия" и является его расширением'
  version '0.0.1'
  url 'https://github.com/rubynovich/redmine_delays'
  author_url 'http://roman.shipiev.me/'
  
  menu :application_menu, :delays, 
    {:controller => :delays, :action => :index}, 
    :caption => :label_delay_plural, 
    :after => :vacation_statuses,
    :if => Proc.new{ User.current.is_vacation_manager?}    
end
