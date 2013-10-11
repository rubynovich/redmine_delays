require 'redmine'

Redmine::Plugin.register :redmine_delays do
  name "Delays"
  author "Roman Shipiev"
  description 'Fixing delays of employees'
  version '0.0.1'
  url 'https://bitbucket.org/rubynovich/redmine_delays'
  author_url 'http://roman.shipiev.me/'

  settings :partial => 'delays/settings'

  Redmine::MenuManager.map :top_menu do |menu| 

    unless menu.exists?(:hr)
      menu.push(:hr, "#", 
                { :after => :projects,
                  :parent => :top_menu, 
                  :caption => :label_hr_menu
                })
    end

    menu.push(:delays, 
              {:controller => :delays, :action => :index},
              { :parent => :hr,
                :caption => :label_delay_plural,
                :if => Proc.new{ User.current.is_delays_manager? }
              })

  end

end

Rails.configuration.to_prepare do

  [:user].each do |cl|
    require "delays_#{cl}_patch"
  end

  require_dependency 'delay'
  require 'time_period_scope'

  [
   [User, DelaysPlugin::UserPatch],
   [Delay, TimePeriodScope]
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end

end
