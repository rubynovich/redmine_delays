require_dependency 'user'

module StaffRequestPlugin

  module UserPatch

    def self.included(base)

      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
      end

    end

    module ClassMethods
    end

    module InstanceMethods

      def is_delays_manager?
        begin
          principal = Principal.find(Setting[:plugin_redmine_delays][:principal_id])
          if principal.is_a?(Group)
            principal.users.include?(self)
          elsif principal.is_a?(User)
            principal == self
          end
        rescue
          nil
        end
      end
      
    end

  end

end
