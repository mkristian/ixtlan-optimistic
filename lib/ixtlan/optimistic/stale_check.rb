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
    module StaleCheck

      def __check( updated_at )
        unless updated_at
          raise ObjectStaleException.new "no 'updated_at' given. could not find #{signature(*args)}."
        end
      end
      
      def __check_stale( updated_at, result )
        if updated_at.is_a?( String )
          updated_at = DateTime.parse( updated_at.sub(/[.][0-9]+/, '') )
        end
        if updated_at != result.updated_at && updated_at.strftime("%Y:%m:%d %H:%M:%S") != result.updated_at.strftime("%Y:%m:%d %H:%M:%S")
          
          raise ObjectStaleException.new "#{self.class} with key #{result.key} is stale for updated at #{updated_at}."
        end
        result
      end
    end
  end
end
