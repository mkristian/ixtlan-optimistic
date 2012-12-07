#
# Copyright (C) 2012 mkristian
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
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