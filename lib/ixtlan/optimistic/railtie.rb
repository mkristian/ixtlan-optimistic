require 'ixtlan/optimistic/active_record'
require 'ixtlan/optimistic/data_mapper'
module Ixtlan
  module Optimistic
    class Railtie < Rails::Railtie

      config.after_initialize do
        if defined? ::DataMapper

          ::DataMapper::Model.append_inclusions(Ixtlan::Optimistic::DataMapper)

        elsif defined? ::ActiveRecord

          ::ActiveRecord::Base.send(:include, 
                                    Ixtlan::Optimistic::ActiveRecord)

        end
      end
    end
  end
end
