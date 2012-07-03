require 'ixtlan/optimistic/object_stale_exception'
module Ixtlan
  module Optimistic
    module DataMapper

      def self.included(base)
        base.class_eval do
          
          def self.optimistic_get(updated_at, *args)
            if updated_at
              updated_at_date = new(:updated_at => updated_at).updated_at
              # TODO make it work with different PKs
              first(:id => args[0], :updated_at.gte => updated_at_date - 0.0005, :updated_at.lte => updated_at_date + 0.0005)
            end
          end

          def self.optimistic_get!(updated_at, *args)
            if updated_at
              result = self.optimistic_get(updated_at, *args)
              raise ObjectStaleException.new "#{self.class} with ID=#{args[0]} is stale" unless result
              result
            else
              raise ObjectStaleException.new "no 'updated_at' given. could not dind #{self.class} with ID=#{args[0]}."              
            end
          end
        end

      end

    end
  end
end
