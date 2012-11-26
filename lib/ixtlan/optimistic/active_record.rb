require 'ixtlan/optimistic/object_stale_exception'
module Ixtlan
  module Optimistic
    module ActiveRecord

      def self.included(base)
        base.class_eval do

          def self.optimistic_find(updated_at, *args)
            if updated_at  
              dummy = self.new
              dummy.updated_at = updated_at
              updated_at_date = dummy.updated_at
              # try different ways to use the date
              # TODO maybe there is a nicer way ??
              # TODO make it work with different PKs
              result = first(:conditions => ["id = ? and updated_at <= ? and updated_at >= ?", args[0], updated_at_date + 0.0005, updated_at_date - 0.0005])
p result
              raise ObjectStaleException.new "#{self} with ID=#{args[0]} is stale" unless result
              result
            else
              raise ObjectStaleException.new "no 'updated_at' given. could not dind #{self} with ID=#{args[0]}."
            end
          end

        end
      end
    end
  end
end
