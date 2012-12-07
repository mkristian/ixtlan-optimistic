# Ixtlan Optimistic #

* [![Build Status](https://secure.travis-ci.org/mkristian/ixtlan-optimistic.png)](http://travis-ci.org/mkristian/ixtlan-optimistic)
* [![Dependency Status](https://gemnasium.com/mkristian/ixtlan-optimistic.png)](https://gemnasium.com/mkristian/ixtlan-remote)
* [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mkristian/ixtlan-optimistic)



it adds optimistic persistence support to DataMapper and ActveRecord using the updated\_at property/attribute which is automatically updated on any change of the model (for datamapper you need dm-timestamps for that). to load a model use `optimistic_get`/`optimistic_get!`/`optimistic_find` respectively where the first argument is the last `updated_at` value which the client has. if the client data is uptodate then the `optimistic_XYZ` method will return the database entity otherwise raise an exception or return nil respectively.

## rails setup ##

automagic via included railtie. just add

    `gem 'ixtlan-optimistic'
	
to your Gemfile.

## datamapper ##

just include `Ixtlan::Optimistic::DataMapper` to your model:

    class User
      include DataMapper::Resource
      include Ixtlan::Optimistic::DataMapper

      property :id, Serial
      property :name, String
  
      timestamps :at
    end
	
you need timestamps to get to work !

## activerecord ##

just add it with

     ::ActiveRecord::Base.send(:include, 
                               Ixtlan::Optimistic::ActiveRecord)

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

meta-fu
-------

enjoy :) 
