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
              cond = {:updated_at.gte => updated_at_date.ago(1), :updated_at.lte => updated_at_date.next }
              index = 0
              properties.key.each do |k|
                cond[k.name] = args[index]
                index += 1
              end
              first(cond)
            end
          end

          def self.optimistic_get!(updated_at, *args)
            if updated_at
              result = self.optimistic_get(updated_at, *args)
              unless result
                # TODO make the whole thing with one query
                self.get!(*args) # check existence
                raise ObjectStaleException.new "#{signature(*args)} is stale"
              end
              result
            else
              raise ObjectStaleException.new "no 'updated_at' given. could not dind #{signature(*args)}."              
            end
          end

          private
          def self.signature(*args)
            s = ""
            index = 0
            properties.key.each do |k|
              s += " @#{k.name}=#{args[index]}"
              index += 1
            end
            "#{self}(#{s.strip})"
          end
        end

      end

    end
  end
end
