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
    module DataMapper

      def self.included(base)
        base.class_eval do
          private

          def self.__check( updated_at )
            unless updated_at
              raise ObjectStaleException.new "no 'updated_at' given. could not find #{signature(*args)}."
            end
          end
         
          def self.__check_stale( updated_at, result )
            updated_at_date = new(:updated_at => updated_at).updated_at
            if updated_at_date != result.updated_at 
              raise ObjectStaleException.new "#{self.class} with key #{result.key} is stale for updated at #{updated_at}."
            end
            result
          end

          public

          def self.optimistic_get(updated_at, *args) 
            __check( updated_at )
            result = get( *args )
            if result
              __check_stale( updated_at, result )
            end
          end
 
          def self.optimistic_get!(updated_at, *args)
            __check( updated_at )
            result = get!( *args )
            __check_stale( updated_at, result )
          end
        end
      end
    end
  end
end